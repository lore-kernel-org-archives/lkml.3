Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab3GXVzV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 17:55:21 -0400
Received: from 1wt.eu ([62.212.114.60]:33422 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822Ab3GXVzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 17:55:19 -0400
Date: Wed, 24 Jul 2013 23:55:15 +0200
From: Willy Tarreau <w@1wt.eu>
To: "Rich, Jason" <jason.rich@tekcomms.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Stoltenberg, Matthew" <matthew.stoltenberg@tekcomms.com>,
        James.Bottomley@suse.de
Subject: Re: Panic at _blk_run_queue on 2.6.32
Message-ID: <20130724215515.GA31938@1wt.eu>
References: <636295BFF4A001418A00F46569A2CD2B161CE88B@US-PLNO-EXM01-P.global.tektronix.net> <20130710202729.GA18877@1wt.eu> <636295BFF4A001418A00F46569A2CD2B161DF7B0@US-PLNO-EXM01-P.global.tektronix.net> <636295BFF4A001418A00F46569A2CD2B161EEE7E@US-PLNO-EXM01-P.global.tektronix.net> <20130722090351.GB7957@1wt.eu> <636295BFF4A001418A00F46569A2CD2B161F4A7C@US-PLNO-EXM01-P.global.tektronix.net> <636295BFF4A001418A00F46569A2CD2B161F7FBC@US-PLNO-EXM01-P.global.tektronix.net> <20130724214847.GA31914@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130724214847.GA31914@1wt.eu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason,

> Thanks to you first. I'll look for any potentially missing patch after
> this one in newer kernels and will keep you informed. If I can't find
> anything, I'll need James' advice on the subject, and maybe we'll need
> more information about your setup, etc...
> 
> > 0ccd644ce6a803b4f7ae5b3b4da614b8a51037cc is the first bad commit
> > commit 0ccd644ce6a803b4f7ae5b3b4da614b8a51037cc
> > Author: James Bottomley <James.Bottomley@suse.de>
> > Date:   Fri Apr 22 10:39:59 2011 -0500
> >     put stricter guards on queue dead checks
> >     
> >     commit 86cbfb5607d4b81b1a993ff689bbd2addd5d3a9b upstream.

(...)

I just found this patch from James which got merged in 2.6.39 and
backported to 2.6.32 which was merged into 2.6.32.40 :

commit c055f5b2614b4f758ae6cc86733f31fa4c2c5844
Author: James Bottomley <James.Bottomley@suse.de>
Date:   Sun May 1 09:42:07 2011 -0500

    [SCSI] fix oops in scsi_run_queue()
    
    The recent commit closing the race window in device teardown:
    
    commit 86cbfb5607d4b81b1a993ff689bbd2addd5d3a9b
    Author: James Bottomley <James.Bottomley@suse.de>
    Date:   Fri Apr 22 10:39:59 2011 -0500
    
        [SCSI] put stricter guards on queue dead checks
    
    is causing a potential NULL deref in scsi_run_queue() because the
    q->queuedata may already be NULL by the time this function is called.
    Since we shouldn't be running a queue that is being torn down, simply
    add a NULL check in scsi_run_queue() to forestall this.
    
    Tested-by: Jim Schutt <jaschut@sandia.gov>
    Cc: stable@kernel.org
    Signed-off-by: James Bottomley <James.Bottomley@suse.de>

So it is possible that your bisection stopped on the first bug which hides
the real one, but this one was fixed in your faulty kernel. I suggest that
you retry on 2.6.32.40 alone, and if it works, then bisect again between
40 and 42 (which I seem to remember was the first faulty one).

Best regards,
Willy

