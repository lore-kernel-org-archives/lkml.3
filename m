Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815AbaIEPZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:25:13 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:34024 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbaIEPZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:25:11 -0400
Message-ID: <5409D5D0.8060801@acm.org>
Date: Fri, 05 Sep 2014 17:25:04 +0200
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: dgilbert@interlog.com, Christoph Hellwig <hch@infradead.org>
CC: SCSI development list <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] scsi_debug: deadlock between completions and surprise
 module removal
References: <5403AB47.3040706@interlog.com> <20140905052402.GA27094@infradead.org> <5409C116.5060702@interlog.com>
In-Reply-To: <5409C116.5060702@interlog.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/14 15:56, Douglas Gilbert wrote:
> With scsi-mq I think many LLDs probably have a new
> race possibility between a surprise rmmod of the LLD
> and another thread presenting a new command at about
> the same time (or another thread's command completing
> around that time). Does anything above the LLD stop
> this happening?
>
> Looking at mpt3sas and hpsa module exit calls, they don't
> seem to guard against this possibility.
>
> The test is pretty easy: build the LLD as a module, load
> it and fire up a multi-thread, libaio fio test on one or
> more devices (SSDs would probably be good) on that LLD.
> While the test is running, do 'rmmod LLD'.

An LLD must call scsi_remove_host() directly or indirectly from the 
module cleanup path. scsi_remove_host() triggers a call to 
blk_cleanup_queue(). That last function sets the flag QUEUE_FLAG_DYING 
which prevents that new I/O is queued and waits until previously queued 
requests have finished before returning.

Bart.

