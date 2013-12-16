Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab3LPVPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 16:15:53 -0500
Received: from smtp205.alice.it ([82.57.200.101]:52036 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332Ab3LPVPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 16:15:52 -0500
Date: Mon, 16 Dec 2013 22:15:42 +0100
From: Gianluca Anzolin <gianluca@sottospazio.it>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Alexander Holler <holler@ahsoftware.de>, marcel@holtmann.org,
        Gustavo Padovan <gustavo@padovan.org>, linux-bluetooth@vger.kernel.org,
        gregkh@linuxfoundation.org, jslaby@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] rfcomm (userland) broken by commit 29cd718b
Message-ID: <20131216211542.GA20419@sottospazio.it>
References: <52AA1854.500@ahsoftware.de>
 <52AA1E62.1030109@hurleysoftware.com>
 <52AA483E.4080706@ahsoftware.de>
 <20131215112413.GA8980@sottospazio.it>
 <52ADB6B7.5010503@hurleysoftware.com>
 <20131215150847.GA10288@sottospazio.it>
 <52AF55B4.6000303@hurleysoftware.com>
 <20131216202044.GA19746@sottospazio.it>
 <20131216202720.GB19746@sottospazio.it>
 <20131216205858.GA20119@sottospazio.it>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <20131216205858.GA20119@sottospazio.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 16, 2013 at 09:58:58PM +0100, Gianluca Anzolin wrote:
> On Mon, Dec 16, 2013 at 09:27:20PM +0100, Gianluca Anzolin wrote:
> > On Mon, Dec 16, 2013 at 09:20:44PM +0100, Gianluca Anzolin wrote:
> > > On Mon, Dec 16, 2013 at 02:34:12PM -0500, Peter Hurley wrote:
> > > > 
> > > > This solution is acceptable to me, but I think the comment should briefly
> > > > explain why this fix is necessary, and the changelog should explain why in detail.
> > > > 
> > > > Perhaps with a fixme comment that rfcomm_tty_install() should just take over
> > > > the port reference (instead of adding one) and rfcomm_tty_cleanup() should
> > > > conditionally release on RFCOMM_RELEASE_ONHUP.
> > > > 
> > > > Because then:
> > > > 1) this fix would not be necessary.
> > > > 2) the release in rfcomm_tty_hangup() would not be necessary
> > > > 3) the second release in rfcomm_release_dev would not be necessary
> > > > 4) the RFCOMM_TTY_RELEASED bit could be removed
> > > > 
> > > > 
> > > > Regards,
> > > > Peter Hurley
> > > 
> > > Taking over the refcount in the install method would certainly look better. I'm
> > > going to test it ASAP :D
> > > 
> > > But why getting rid of the release in in rfcomm_tty_hangup()?
> > > We could lose the bluetooth connection at any time and the dlc callback
> > > would have to hangup the tty (and release the port if necessary).
> > > 
> > > Also the RFCOMM_TTY_RELEASED bit should still be necessary if the port is
> > > created without the RFCOMM_RELEASE_ONHUP flag.
> > > 
> > > Besides any process could release the port behind us (with the command rfcomm
> > > release rfcomm1 for example).
> > > 
> > > Gianluca
> > 
> > Nevermind I figured it out the reason...
> 
> I'm testing the attached patch ATM, which does what you described. It works
> very well.
> 
> It doesn't remove the RFCOMM_TTY_RELEASE flag yet, another patch should remove
> that bit.

ok, replying to myself again (sorry for that). RFCOMM_TTY_RELEASE cannot go
away. We have still to manage the case where the port is opened without
RFCOMM_RELEASE_ONHUP.

This last patch does release the port in that situation.

Tested with:
# rfcomm bind 1 <addr>
# rfcomm release 1

and with
# rfcomm connect 1 <addr>

Thanks,
Gianluca

--6c2NcOVqGQ03X4Wi
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="rfc3.patch"

diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index 84fcf9f..0357dcf 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -437,7 +437,8 @@ static int rfcomm_release_dev(void __user *arg)
 		tty_kref_put(tty);
 	}
 
-	if (!test_and_set_bit(RFCOMM_TTY_RELEASED, &dev->flags))
+	if (!test_bit(RFCOMM_RELEASE_ONHUP, &dev->flags) &&
+	    !test_and_set_bit(RFCOMM_TTY_RELEASED, &dev->flags))
 		tty_port_put(&dev->port);
 
 	tty_port_put(&dev->port);
@@ -673,6 +674,14 @@ static int rfcomm_tty_install(struct tty_driver *driver, struct tty_struct *tty)
 	if (err)
 		rfcomm_tty_cleanup(tty);
 
+	/* take over the tty_port reference if it was created with the
+	 * flag RFCOMM_RELEASE_ONHUP. This will force the release of the port
+	 * when the last process closes the tty. This behaviour is expected by
+	 * userspace.
+	 */
+	if (test_bit(RFCOMM_RELEASE_ONHUP, &dev->flags))
+		tty_port_put(&dev->port);
+
 	return err;
 }
 
@@ -1010,10 +1019,6 @@ static void rfcomm_tty_hangup(struct tty_struct *tty)
 	BT_DBG("tty %p dev %p", tty, dev);
 
 	tty_port_hangup(&dev->port);
-
-	if (test_bit(RFCOMM_RELEASE_ONHUP, &dev->flags) &&
-	    !test_and_set_bit(RFCOMM_TTY_RELEASED, &dev->flags))
-		tty_port_put(&dev->port);
 }
 
 static int rfcomm_tty_tiocmget(struct tty_struct *tty)

--6c2NcOVqGQ03X4Wi--
