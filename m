Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbaIBOHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 10:07:17 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:36096 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbaIBOHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 10:07:14 -0400
Date: Tue, 2 Sep 2014 17:05:32 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Benjamin Romer <benjamin.romer@unisys.com>,
        David Kershner <david.kershner@unisys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, sparmaintainer@unisys.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: unisys: uislib: uisqueue.c: fixed sparse
 warning of context imbalance
Message-ID: <20140902140532.GD6600@mwanda>
References: <1409656187-14215-1-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409656187-14215-1-git-send-email-sudipm.mukherjee@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 04:39:47PM +0530, Sudip Mukherjee wrote:
> fixed sparse warning : context imbalance in 'do_locked_client_insert'
> 			 different lock contexts for basic block
> 
> spin_unlock_irqrestore is called at a later stage before returning 
> from the function if locked is 1.
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>

This doesn't match the email address you are using.

Really, your patch isn't bad but I would prefer if you re-wrote this
entire function because currently it is garbage.

static u8
do_locked_client_insert(struct uisqueue_info *queueinfo,
                        unsigned int whichqueue,
                        void *pSignal,
                        spinlock_t *lock,
                        unsigned char issueInterruptIfEmpty,
                        u64 interruptHandle, u8 *channelId)
{
        unsigned long flags;
        unsigned char queueWasEmpty;

        spin_lock_irqsave(lock, flags);

        if (!ULTRA_CHANNEL_CLIENT_ACQUIRE_OS(queueinfo->chan, channelId, NULL))
                goto unlock;

        queueWasEmpty = visor_signalqueue_empty(queueinfo->chan, whichqueue);
        if (!visor_signal_insert(queueinfo->chan, whichqueue, pSignal))
                goto release;
        ULTRA_CHANNEL_CLIENT_RELEASE_OS(queueinfo->chan, channelId, NULL);
        spin_unlock_irqrestore(lock, flags);

        queueinfo->packets_sent++;

        return 1;

release:
        ULTRA_CHANNEL_CLIENT_RELEASE_OS(queueinfo->chan, channelId, NULL);
unlock:
        spin_unlock_irqrestore(lock, flags);

        return 0;
}

The queueWasEmpty variable is kind of silly.  It should just be an int
or maybe a bool if you are being pedantic but instead we very
specifically set it to be an unsigned variable of the incorrect type.
Also we don't use queueWasEmpty at all.  I think we could delete it...

The problem with the original code was that the error paths and the
success paths were mixed together like spaghetti.  If you separate them
out and unwind in the proper order with normal label names then the
code is easy to understand.

regards,
dan carpenter

