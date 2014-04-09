Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933444AbaDIO57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 10:57:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:62268 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932807AbaDIO55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 10:57:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,826,1389772800"; 
   d="scan'208";a="517557317"
Message-ID: <53455FC6.7080009@intel.com>
Date: Wed, 09 Apr 2014 22:57:10 +0800
From: Xiao Jin <jin.xiao@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: oneukum@suse.de, jhovold@gmail.com, gnomes@lxorguk.ukuu.org.uk
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, david.a.cohen@linux.intel.com,
        yanmin.zhang@intel.com, jin.xiao@intel.com
Subject: Re: [PATCH] cdc-acm: some enhancement on acm delayed write
References: <53436770.9090008@intel.com>
In-Reply-To: <53436770.9090008@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks all for the review. We meet with the problems when developing 
product. I would like to explain my understanding.

On 04/08/2014 11:05 AM, Xiao Jin wrote:
>
> We find two problems on acm tty write delayed mechanism.
> (1) When acm resume, the delayed wb will be started. But now
> only one write can be saved during acm suspend. More acm write
> may be abandoned.

The scenario usually happened when user space write series AT after acm 
suspend. If acm accept the first AT, what's the reason for acm to refuse 
the second AT? If write return 0, user space will try repeatedly until 
resume. It looks simpler that acm accept all the data and sent out urb 
when resume.

> (2) acm tty port ASYNCB_INITIALIZED flag will be cleared when
> close. If acm resume callback run after ASYNCB_INITIALIZED flag
> cleared, there will have no chance for delayed write to start.
> That lead to acm_wb.use can't be cleared. If user space open
> acm tty again and try to setd, tty will be blocked in
> tty_wait_until_sent for ever.
>

We see tty write and close concurrently after acm suspend in this case. 
It looks no method to avoid it from tty layer. acm_tty_write and 
acm_resume call after acm_port_shutdown. It looks any action in 
acm_port_shutdown can't solve the problem. As acm has accepted the user 
space data, we can only find a way to send out urb. I feel anyway to 
discard the data looks like a lie to user space.

In my understanding acm should accept data as much as possible, and send 
out urb as soon as possible. What do you think of?

Br, Jin
