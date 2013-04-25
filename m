Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933291Ab3DYWcN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 18:32:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57534 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396Ab3DYWcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 18:32:11 -0400
Date: Thu, 25 Apr 2013 15:32:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        linux-usb <linux-usb@vger.kernel.org>,
        usb-storage <usb-storage@lists.one-eyed-alien.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] usb: storage: Convert US_DEBUGP to usb_stor_dbg
Message-Id: <20130425153209.5b590422dbd249a5e19ac570@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.02.1304221234270.16385@chino.kir.corp.google.com>
References: <Pine.LNX.4.44L0.1304171426460.1623-100000@iolanthe.rowland.org>
	<1366254055.28609.61.camel@joe-AO722>
	<20130419173503.GA27495@kroah.com>
	<1366397040.3901.45.camel@joe-AO722>
	<alpine.DEB.2.02.1304221234270.16385@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Apr 2013 12:35:26 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> On Fri, 19 Apr 2013, Joe Perches wrote:
> 
> > @@ -966,11 +934,13 @@ static int realtek_cr_autosuspend_setup(struct us_data *us)
> >  static void realtek_cr_destructor(void *extra)
> >  {
> >  	struct rts51x_chip *chip = (struct rts51x_chip *)extra;
> > -
> > -	US_DEBUGP("%s: <---\n", __func__);
> > +	struct us_data *us;
> >  
> >  	if (!chip)
> >  		return;
> > +
> > +	us = chip->us;
> > +
> >  #ifdef CONFIG_REALTEK_AUTOPM
> >  	if (ss_en) {
> >  		del_timer(&chip->rts51x_suspend_timer);
> 
> >From linux-next:
> 
> drivers/usb/storage/realtek_cr.c: In function 'realtek_cr_destructor':
> drivers/usb/storage/realtek_cr.c:942:11: error: 'struct rts51x_chip' has no member named 'us'
> 
> chip->us here is only defined when CONFIG_REALTEK_AUTOPM is enabled.

local var `us' doesn't get used by anything and it's unclear why that
patch added it?  



From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/usb/storage/realtek_cr.c: fix build

Remove unused local `us', which broke the build.  Also nuke an unneeded
cast.

Repairs 191648d03d20 ("usb: storage: Convert US_DEBUGP to usb_stor_dbg").

Cc: Joe Perches <joe@perches.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/usb/storage/realtek_cr.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/usb/storage/realtek_cr.c~drivers-usb-storage-realtek_crc-fix-build drivers/usb/storage/realtek_cr.c
--- a/drivers/usb/storage/realtek_cr.c~drivers-usb-storage-realtek_crc-fix-build
+++ a/drivers/usb/storage/realtek_cr.c
@@ -933,14 +933,11 @@ static int realtek_cr_autosuspend_setup(
 
 static void realtek_cr_destructor(void *extra)
 {
-	struct rts51x_chip *chip = (struct rts51x_chip *)extra;
-	struct us_data *us;
+	struct rts51x_chip *chip = extra;
 
 	if (!chip)
 		return;
 
-	us = chip->us;
-
 #ifdef CONFIG_REALTEK_AUTOPM
 	if (ss_en) {
 		del_timer(&chip->rts51x_suspend_timer);
_


Left unfixed:

drivers/usb/storage/realtek_cr.c:628: warning: 'config_autodelink_before_power_down' defined but not used
drivers/usb/storage/realtek_cr.c:698: warning: 'fw5895_init' defined but not used

