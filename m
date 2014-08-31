Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393AbaHaLi1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 07:38:27 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:48917 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaHaLiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 07:38:25 -0400
Date: Sun, 31 Aug 2014 07:38:22 -0400
From: Tejun Heo <tj@kernel.org>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, falcon@meizu.com,
        Takashi Iwai <tiwai@suse.de>, arjan@linux.intel.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        penguin-kernel@i-love.sakura.ne.jp,
        Joseph Salisbury <joseph.salisbury@canonical.com>, bpoirier@suse.de,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC v1 0/3] driver-core: add asynch module loading support
Message-ID: <20140831113822.GF19853@htj.dyndns.org>
References: <1409475800-17573-1-git-send-email-mcgrof@do-not-panic.com>
 <20140831101358.GB19853@htj.dyndns.org>
 <20140831110200.GC19853@htj.dyndns.org>
 <CANq1E4QFtTrCU8eq67AqeUO1v9EAZnAfaHJW4CnJkh0KKq9XmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANq1E4QFtTrCU8eq67AqeUO1v9EAZnAfaHJW4CnJkh0KKq9XmA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Rusty for module loading)

Hello,

On Sun, Aug 31, 2014 at 01:25:03PM +0200, David Herrmann wrote:
> On Sun, Aug 31, 2014 at 1:02 PM, Tejun Heo <tj@kernel.org> wrote:
> > @@ -689,9 +704,23 @@ int bus_add_driver(struct device_driver *drv)
> >
> >         klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers);
> >         if (drv->bus->p->drivers_autoprobe) {
> > -               error = driver_attach(drv);
> > -               if (error)
> > -                       goto out_unregister;
> > +               struct driver_attach_work *daw;

Oops, this probably should go inside the below if block.

> > +
> > +               if (drv->owner) {
> > +                       daw = kzalloc(sizeof(*daw), GFP_KERNEL);
> > +                       if (!daw) {
> > +                               error = -ENOMEM;
> > +                               goto out_unregister;
> > +                       }
> > +
> > +                       INIT_WORK(&daw->work, driver_attach_workfn);
> > +                       daw->driver = drv;
> > +                       queue_work(driver_attach_wq, &daw->work);
> 
> Doesn't this break on-demand cdev initialization? We currently call
> request_module() on open() for unclaimed major/minor combinations. If
> driver_attach() is no longer part of module_init(), there is no
> guarantee the driver created the cdev before request_module() returns.

Right, yeah, this really looks like something we'd need to switch per
insmod instance.  It looks like driver core needs a generic parameter
to tell it to whether drive probing asynchronously to module loading
or not.  Maybe we can add a generic driver param like
"driver_async_probe"?

> I actually like this "deferred attach" approach, so this is not meant
> as counter-argument. We just need to make sure to have a notion of
> "settled modules" so we know how long to wait after loading a module.

Another way could be making module-generic pollable file in the
module's sysfs dir to indicate "full init completion", which would map
to probing completion for drivers; however, given that we need to keep
the synchronous behavior by default for compatibility, I don't think
that buys us much.

Thanks.

-- 
tejun
