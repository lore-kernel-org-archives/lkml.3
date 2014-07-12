Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbaGLVSM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 17:18:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48563 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaGLVSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 17:18:08 -0400
Date: Sat, 12 Jul 2014 14:22:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Stephen Warren <swarren@nvidia.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jingoo Han <jg1.han@samsung.com>, linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        linux-serial@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Aaron Sierra <asierra@xes-inc.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH V8 2/2] serial/uart/8250: Add tunable RX interrupt
 trigger I/F of FIFO buffers
Message-ID: <20140712212237.GA7891@kroah.com>
References: <20140530061617.21929.25777.stgit@yunodevel>
 <20140530061622.21929.82083.stgit@yunodevel>
 <20140710002837.GA5429@kroah.com>
 <20140710153157.57902972@alan.etchedpixels.co.uk>
 <20140710231637.GB9423@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140710231637.GB9423@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 04:16:37PM -0700, Greg Kroah-Hartman wrote:
> On Thu, Jul 10, 2014 at 03:31:57PM +0100, One Thousand Gnomes wrote:
> > > I really don't like the way that the tty core has been changed to handle
> > > multiple attribute groups, as I feel tty drivers shouldn't be creating
> > > "special" sysfs files, depending on what driver is bound to them.
> > 
> > The intent isn't that it is "special" but that it can be propogated to
> > others as and when they wish to provide it.
> >  
> > > Usually we have handled this using tools like 'stty' and ioctls, right?
> > > Surely there is an ioctl to control the interrupt level, right?  Hasn't
> > > this been covered before somehow?
> > 
> > No, and the direction when this started was to use sysfs as we have also
> > been moving all the other attributes towards sysfs and has been since
> > 2012.
> > 
> > TTY devices do have lots of strange attributes and right now many of them
> > are only programmable by using device tree and rebooting.
> 
> Ok.  Hm, there has to be a better way to do the group sysfs file
> handling...
> 
> Let me work on this tomorrow and see what I can come up with.  We should
> be able to use the is_visable() attribute to create/notcreate the
> attribute where needed...

Ok, how about this patch instead of your first one?

It creates a new port attribute, attr_group, which you should be able to
set in the 8250 driver if you device needs it.  Then the serial core
will handle the dynamic group creation, without relying on a "magic"
number of groups.  Very close to your patch, but now it's dynamic, and
no fixed array, and no crazy casting in the
tty_port_register_device_attr() call.

I have not tested this, only test built the code.

If it works for you, can you redo your second patch, and then send both
of these back to me so that I can apply them?

thanks,

greg k-h


---------------

Subject: [PATCH] Serial: allow port drivers to have a default attribute group

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Some serial drivers (like 8250), want to add sysfs files.  We need to do
so in a race-free way, so allow any port to be able to specify an
attribute group that should be added at device creation time.

Based on a patch from Yoshihiro YUNOMAE
<yoshihiro.yunomae.ez@hitachi.com>

Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index b70095e55df6..b8c3a5419060 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2564,11 +2564,6 @@ static const struct attribute_group tty_dev_attr_group = {
 	.attrs = tty_dev_attrs,
 	};
 
-static const struct attribute_group *tty_dev_attr_groups[] = {
-	&tty_dev_attr_group,
-	NULL
-	};
-
 
 /**
  *	uart_add_one_port - attach a driver-defined port structure
@@ -2586,6 +2581,7 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
 	struct tty_port *port;
 	int ret = 0;
 	struct device *tty_dev;
+	int num_groups;
 
 	BUG_ON(in_interrupt());
 
@@ -2619,12 +2615,26 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
 
 	uart_configure_port(drv, state, uport);
 
+	num_groups = 2;
+	if (uport->attr_group)
+		num_groups++;
+
+	uport->tty_groups = kzalloc(sizeof(struct attribute_group *) * num_groups,
+			     GFP_KERNEL);
+	if (!uport->tty_groups) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	uport->tty_groups[0] = &tty_dev_attr_group;
+	if (uport->attr_group)
+		uport->tty_groups[1] = uport->attr_group;
+
 	/*
 	 * Register the port whether it's detected or not.  This allows
 	 * setserial to be used to alter this port's parameters.
 	 */
 	tty_dev = tty_port_register_device_attr(port, drv->tty_driver,
-			uport->line, uport->dev, port, tty_dev_attr_groups);
+			uport->line, uport->dev, port, uport->tty_groups);
 	if (likely(!IS_ERR(tty_dev))) {
 		device_set_wakeup_capable(tty_dev, 1);
 	} else {
@@ -2703,6 +2713,7 @@ int uart_remove_one_port(struct uart_driver *drv, struct uart_port *uport)
 	 */
 	if (uport->type != PORT_UNKNOWN)
 		uport->ops->release_port(uport);
+	kfree(uport->tty_groups);
 
 	/*
 	 * Indicate that there isn't a port here anymore.
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 5bbb809ee197..cf3a1e789bf5 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -199,6 +199,8 @@ struct uart_port {
 	unsigned char		suspended;
 	unsigned char		irq_wake;
 	unsigned char		unused[2];
+	struct attribute_group	*attr_group;		/* port specific attributes */
+	const struct attribute_group **tty_groups;	/* all attributes (serial core use only) */
 	void			*private_data;		/* generic platform data pointer */
 };
 
