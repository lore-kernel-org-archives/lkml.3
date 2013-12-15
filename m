Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab3LOPOw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 10:14:52 -0500
Received: from smtp206.alice.it ([82.57.200.102]:32585 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab3LOPOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 10:14:51 -0500
X-Greylist: delayed 352 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Dec 2013 10:14:50 EST
Date: Sun, 15 Dec 2013 16:08:47 +0100
From: Gianluca Anzolin <gianluca@sottospazio.it>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Alexander Holler <holler@ahsoftware.de>, marcel@holtmann.org,
        Gustavo Padovan <gustavo@padovan.org>, linux-bluetooth@vger.kernel.org,
        gregkh@linuxfoundation.org, jslaby@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] rfcomm (userland) broken by commit 29cd718b
Message-ID: <20131215150847.GA10288@sottospazio.it>
References: <1377620926-23370-1-git-send-email-gianluca@sottospazio.it>
 <20130919162413.GG4006@joana>
 <52AA1854.500@ahsoftware.de>
 <52AA1E62.1030109@hurleysoftware.com>
 <52AA483E.4080706@ahsoftware.de>
 <20131215112413.GA8980@sottospazio.it>
 <52ADB6B7.5010503@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="azLHFNyN32YCQGCU"
Content-Disposition: inline
In-Reply-To: <52ADB6B7.5010503@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 15, 2013 at 09:03:35AM -0500, Peter Hurley wrote:
> On 12/15/2013 06:24 AM, Gianluca Anzolin wrote:
> >On Fri, Dec 13, 2013 at 12:35:26AM +0100, Alexander Holler wrote:
> >>Am 12.12.2013 21:36, schrieb Peter Hurley:
> >>
> >>>>What currently happens is that when one kills rfcomm (and any other
> >>>>terminal which might use that tty), the entry in /dev doesn't
> >>>>disappear. That means the same call to refcomm with the same device
> >>>>(e.g. [/dev/]rfcomm1 doesn't work.
> >>>
> >>>Thanks for the report, Alexander.
> >>>
> >>>Point 4 above details a different situation; something else is
> >>>happening.
> >>>
> >>>Would you please detail the necessary steps to reproduce this regression?
> >>>(How do you 'kill' rfcomm? etc.  Shell command lines would be best.)
> >>
> >>Just call
> >>
> >>rfcomm connect rfcomm9 01:23:45:67:89:ab
> >>
> >>wait until the connection happened  (a message will appear) and then
> >>press ctrl-c. This still terminates the bluetooth connection, but the
> >>device in /dev is now left.
> >
> >Yes I'm able to reproduce the regression which is indeed caused by that
> >commit.
> >
> >However I'm puzzled. Surely there is a fifth case I didn't cover because
> >when rfcomm_dev_state_change() is called, the tty_port is there but the tty is
> >not, and therefore I cannot get a reference to it and send the HUP.
> 
> There is a fifth case, but it's crazy.
> 
> The tty has been properly shutdown and destroyed because the tty file handle
> was closed, not hungup. The rfcomm device reference was properly put
> when the tty was released.
> 
> But when the remote hangs up (and sends disc), then rfcomm_dev_state_change()
> is called -- to kill the port reference (thus the rfcomm device) that was
> instantiated locally! Ridiculous. Doubly ridiculous because it's the local
> port shutdown that closes the dlc locally that sends the disconnect (and sets
> the local dlc state) that triggers the received rfcomm_dev_state_change()!
> 
> If this behavior is desirable (or necessary because it's been exposed to
> userspace), then why was the design ever reference-counted to begin with?
> 
> Regards,
> Peter Hurley

The attached patch fixes the regression by releasing the tty_port in the
shutdown method(). This way we can avoid strange games in the dlc callback
where we are constrained by the dlc lock.

If this kind of approach is acceptable I will submit the patch for inclusion in
a separate email.

Thanks,
Gianluca

--azLHFNyN32YCQGCU
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="rfc.patch"

diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index 84fcf9f..917b441 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -129,6 +129,11 @@ static void rfcomm_dev_shutdown(struct tty_port *port)
 
 	/* close the dlc */
 	rfcomm_dlc_close(dev->dlc, 0);
+
+	/* release the port if it was created with the flag RELEASE_ONHUP */
+	if (test_bit(RFCOMM_RELEASE_ONHUP, &dev->flags) &&
+	    !test_and_set_bit(RFCOMM_TTY_RELEASED, &dev->flags))
+		tty_port_put(&dev->port);
 }
 
 static const struct tty_port_operations rfcomm_port_ops = {

--azLHFNyN32YCQGCU--
