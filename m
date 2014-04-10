Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965568AbaDJICI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 04:02:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43299 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934654AbaDJICF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 04:02:05 -0400
Message-ID: <1397116923.4802.10.camel@linux-fkkt.site>
Subject: Re: [PATCH] cdc-acm: some enhancement on acm delayed write
From: Oliver Neukum <oneukum@suse.de>
To: Xiao Jin <jin.xiao@intel.com>
Cc: jhovold@gmail.com, gnomes@lxorguk.ukuu.org.uk, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        david.a.cohen@linux.intel.com, yanmin.zhang@intel.com
Date: Thu, 10 Apr 2014 10:02:03 +0200
In-Reply-To: <53455FC6.7080009@intel.com>
References: <53436770.9090008@intel.com> <53455FC6.7080009@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-09 at 22:57 +0800, Xiao Jin wrote:
> Thanks all for the review. We meet with the problems when developing 
> product. I would like to explain my understanding.
> 
> On 04/08/2014 11:05 AM, Xiao Jin wrote:
> >
> > We find two problems on acm tty write delayed mechanism.
> > (1) When acm resume, the delayed wb will be started. But now
> > only one write can be saved during acm suspend. More acm write
> > may be abandoned.
> 
> The scenario usually happened when user space write series AT after acm 
> suspend. If acm accept the first AT, what's the reason for acm to refuse 
> the second AT? If write return 0, user space will try repeatedly until 
> resume. It looks simpler that acm accept all the data and sent out urb 
> when resume.

No. We cannot accept an arbitrary amount of data. It would let any
user OOM the system. There will have to be an arbitrary limit.
The simplest limit is 1 urb. And that is because we said that we
are ready to accept data.

> > (2) acm tty port ASYNCB_INITIALIZED flag will be cleared when
> > close. If acm resume callback run after ASYNCB_INITIALIZED flag
> > cleared, there will have no chance for delayed write to start.
> > That lead to acm_wb.use can't be cleared. If user space open
> > acm tty again and try to setd, tty will be blocked in
> > tty_wait_until_sent for ever.
> >
> 
> We see tty write and close concurrently after acm suspend in this case. 
> It looks no method to avoid it from tty layer. acm_tty_write and

There is a delay user space can set.

> acm_resume call after acm_port_shutdown. It looks any action in 
> acm_port_shutdown can't solve the problem. As acm has accepted the user 
> space data, we can only find a way to send out urb. I feel anyway to 
> discard the data looks like a lie to user space.
> 
> In my understanding acm should accept data as much as possible, and send 
> out urb as soon as possible. What do you think of?

There's certainly no problem with sending out the data. Yet
simply resuming the device in shutdown() should do the job.

	Regards
		Oliver


