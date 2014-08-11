Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbaHKTI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 15:08:29 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:50951 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbaHKTI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 15:08:27 -0400
Date: Mon, 11 Aug 2014 12:08:23 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Sanjeev Sharma <sanjeev_sharma@mentor.com>, gregkh@linuxfoundation.org,
        kraxel@redhat.com, mdharm-usb@one-eyed-alien.net,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] uas: replace WARN_ON_ONCE() with assert_spin_locked().
Message-ID: <20140811190823.GA18503@roeck-us.net>
References: <1407743966-25325-1-git-send-email-sanjeev_sharma@mentor.com>
 <20140811181905.GA25727@roeck-us.net>
 <53E9118B.3020309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E9118B.3020309@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 11, 2014 at 08:55:07PM +0200, Hans de Goede wrote:
> Hi,
> 
> On 08/11/2014 08:19 PM, Guenter Roeck wrote:
> > On Mon, Aug 11, 2014 at 01:29:26PM +0530, Sanjeev Sharma wrote:
> >> spin_is_locked() always return false in uniprocessor configuration and therefore it
> >> would be advise to repalce with assert_spin_locked().
> >>
> >> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
> >> ---
> >>  drivers/usb/storage/uas.c | 8 ++++----
> >>  1 file changed, 4 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> >> index 3f42785..8e5877d 100644
> >> --- a/drivers/usb/storage/uas.c
> >> +++ b/drivers/usb/storage/uas.c
> >> @@ -154,7 +154,7 @@ static void uas_mark_cmd_dead(struct uas_dev_info *devinfo,
> >>  	struct scsi_cmnd *cmnd = container_of(scp, struct scsi_cmnd, SCp);
> >>  
> >>  	uas_log_cmd_state(cmnd, caller);
> >> -	WARN_ON_ONCE(!spin_is_locked(&devinfo->lock));
> >> +	assert_spin_locked(&devinfo->lock);
> > 
> > Seems to me that replacing WARN_ON_ONCE (which may be annoying but only
> > creates a traceback, and only once) with assert_spin_locked (which
> > crashes the kernel) is a bit drastic.
> 
> I can see your point, but so far these paranoia checks have never triggered,
> and having them trigger _always_ one some uni-processor (which is the reason
> for this patch) to me seems the worse problem of the 2.
> 
If those are just paranoia checks, it might make sense to use
lockdep_assert_held() to reduce runtime overhead if lockdep
debugging is disabled.

> Ideally we would have a warn_spin_not_locked or such ...
> 
There is WARN_ON_SMP, which might have been a better choice if the _ONCE isn't
that important (which one should think if it is ok to crash the kernel if the
problem is seen).

Guenter
