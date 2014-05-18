Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaERSBu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 14:01:50 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:1181 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbaERSBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 14:01:49 -0400
Message-ID: <1400436100.9463.4.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 3/5] ipc,msg: always respect MSG_NOERROR
From: Davidlohr Bueso <davidlohr@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: akpm@linux-foundation.org, aswin@hp.com, linux-kernel@vger.kernel.org
Date: Sun, 18 May 2014 11:01:40 -0700
In-Reply-To: <53784ABD.8080209@colorfullife.com>
References: <1400012857-11733-1-git-send-email-davidlohr@hp.com>
	 <1400012857-11733-4-git-send-email-davidlohr@hp.com>
	 <53784ABD.8080209@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-05-18 at 07:53 +0200, Manfred Spraul wrote:
> On 05/13/2014 10:27 PM, Davidlohr Bueso wrote:
> > When specifying the MSG_NOERROR flag, receivers can avoid returning
> > error (E2BIG) and just truncate the message text, if it is too large.
> >
> > Currently, this logic is only respected when there are already pending
> > messages in the queue.
> Do you have a test case? The code should handle that
> (See below)
> >   Fix this for the case when there are only
> > receivers waiting for a msg to be sent. In order for this to work, save
> > the flags in the msg_receiver struct as it must be used later when
> > doing the pipeline send.
> No, it is sufficient to set the message size to infinity.
> 
> > Also do some pipeline_send() cleanups while at it.
> No - please don't mix cleanups with bugfixes.
> 
> >   
> >   long do_msgsnd(int msqid, long mtype, void __user *mtext,
> > @@ -901,6 +907,7 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp, int msgfl
> >   		list_add_tail(&msr_d.r_list, &msq->q_receivers);
> >   		msr_d.r_tsk = current;
> >   		msr_d.r_msgtype = msgtyp;
> > +		msr_d.r_msgflg = msgflg;
> >   		msr_d.r_mode = mode;
> >   		if (msgflg & MSG_NOERROR)
> >   			msr_d.r_maxsize = INT_MAX;
>     ^^^^^^
> This code should handle MSG_NOERROR:
> If MSG_NOERROR is set, then maxsize is set to INT_MAX, therefore -E2BIG 
> should never be returned.

Yeah, I noticed that, but I'd still prefer keeping the check, even if
redundant. It's free and by keeping both scenarios where there are and
aren't msg waiting in the queue the code becomes easier to read.

Thanks,
Davidlohr

