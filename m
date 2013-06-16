Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab3FPRiL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 13:38:11 -0400
Received: from smtp1.uu.se ([130.238.7.54]:53142 "EHLO smtp1.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182Ab3FPRiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 13:38:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20925.63308.865094.602537@pilspetsen.it.uu.se>
Date: Sun, 16 Jun 2013 19:35:08 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Ross Lagerwall <rosslagerwall@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>, linux-serial@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] tty/vt: Return EBUSY if deallocating VT1 and it is busy
In-Reply-To: <1371248665-1176-1-git-send-email-rosslagerwall@gmail.com>
References: <20130614213543.GA1896@kroah.com>
	<1371248665-1176-1-git-send-email-rosslagerwall@gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ross Lagerwall writes:
 > Commit 421b40a6286e ("tty/vt: Fix vc_deallocate() lock order") changed
 > the behavior when deallocating VT 1.  Previously if trying to
 > deallocate VT1 and it is busy, we would return EBUSY.  The commit
 > changed this to return 0 (success).
 > 
 > This commit restores the old behavior.
 > 
 > Signed-off-by: Ross Lagerwall <rosslagerwall@gmail.com>

This solves the VT blanking regression I've seen with the 3.10-rc
kernels.

Tested-by: Mikael Pettersson <mikpe@it.uu.se>

 > ---
 > On 06/14/2013 05:35 PM, Greg KH wrote:
 > > p.s. In the future, please cc: the people who handled the patch you are
 > > asking about, otherwise stuff like this often gets missed in the noise
 > > of lkml.
 > 
 > Yes, sorry about that.  I only remembered after I sent the email.
 > 
 >  drivers/tty/vt/vt_ioctl.c | 5 +----
 >  1 file changed, 1 insertion(+), 4 deletions(-)
 > 
 > diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
 > index fc2c06c..2bd78e2 100644
 > --- a/drivers/tty/vt/vt_ioctl.c
 > +++ b/drivers/tty/vt/vt_ioctl.c
 > @@ -289,13 +289,10 @@ static int vt_disallocate(unsigned int vc_num)
 >  	struct vc_data *vc = NULL;
 >  	int ret = 0;
 >  
 > -	if (!vc_num)
 > -		return 0;
 > -
 >  	console_lock();
 >  	if (VT_BUSY(vc_num))
 >  		ret = -EBUSY;
 > -	else
 > +	else if (vc_num)
 >  		vc = vc_deallocate(vc_num);
 >  	console_unlock();
 >  
 > -- 
 > 1.8.3.1
 > 
 > --
 > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
 > the body of a message to majordomo@vger.kernel.org
 > More majordomo info at  http://vger.kernel.org/majordomo-info.html
 > Please read the FAQ at  http://www.tux.org/lkml/
 > 
