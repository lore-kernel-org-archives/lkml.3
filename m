Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711AbaE1Q43 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 12:56:29 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:2981 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751626AbaE1Q41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 12:56:27 -0400
Date: Wed, 28 May 2014 12:56:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: "Chen, Gong" <gong.chen@linux.intel.com>, tony.luck@intel.com,
        m.chehab@samsung.com, linux-acpi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7 v6] trace, RAS: Add eMCA trace event interface
Message-ID: <20140528125625.6f6dcf7f@gandalf.local.home>
In-Reply-To: <20140528163452.GF17196@pd.tnic>
References: <1400142646-10127-1-git-send-email-gong.chen@linux.intel.com>
	<1401247938-22125-1-git-send-email-gong.chen@linux.intel.com>
	<1401247938-22125-2-git-send-email-gong.chen@linux.intel.com>
	<20140528112832.5f83c66b@gandalf.local.home>
	<20140528163452.GF17196@pd.tnic>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2014 18:34:52 +0200
Borislav Petkov <bp@alien8.de> wrote:
 
> Well, they're constructed from a bunch of values which are checked for
> validity first:
> 
> http://lkml.kernel.org/r/1400142646-10127-4-git-send-email-gong.chen@linux.intel.com

OK, looks like you are saving a bunch of integers.

> 
> We probably could get rid of the fru* things by reading them out from
> ACPI and enumerating them and issuing only an index here which the slow
> path decodes.
> 
> The others we can split into fields again which should definitely make
> the record smaller. Fields are defined in struct cper_sec_mem_err.
> 
> The thing is, this TP needs to be designed properly before we expose it
> to the world and so that hoperfully most future uses are covered.

My concern is passing in a large string and wasting a lot of the ring
buffer space. The max you can hold per event is just under a page size
(4k). And all these strings add up. If it happens to be 512bytes, then
you end up with one event per page.

Instead of making that a huge string, what about a dynamic array of
special structures?


struct __attribute__((__packed__)) cper_sec_mem_rec {
	short type;
	int data;
};


static struct cper_sec_mem_rec mem_location[CPER_REC_LEN];

then have the:

 	if (mem->validation_bits & CPER_MEM_VALID_NODE) {
		msg[n].type = CPER_MEM_VALID_NODE_TYPE;
		msg[n++].data = mem->node;
	}
	if (mem->validation_bits & CPER_MEM_VALID_CARD) {
		msg[n].type = CPER_MEM_VALID_CARD_TYPE;
		msg[n++].data = mem->card;
	}
	if (mem->validation_bits & CPER_MEM_VALID_MODULE) {
[ and so on ]


Then return the array of msg and the length and you can record this
into the dynamic array in the tracepoint.

Then you have the type and data saved, the TP_printk() can parse it.
You can create your own handler for it to do it nicely (see the ftrace
version of __print_symbol() and friends).

Makes the tracepoint much more compact.

-- Steve
