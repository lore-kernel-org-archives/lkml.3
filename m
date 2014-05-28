Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaE1Qxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 12:53:43 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:38962 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaE1Qxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 12:53:41 -0400
Subject: Re: [RFC PATCH 0/3] RAS: Correctable Errors Collector thing
From: Max Asbock <masbock@linux.vnet.ibm.com>
Reply-To: masbock@linux.vnet.ibm.com
To: Chen Yucong <slaoub@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-edac <linux-edac@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Tony Luck <tony.luck@intel.com>
In-Reply-To: <1401245361.5049.6.camel@cyc>
References: <1401197235-13440-1-git-send-email-bp@alien8.de>
	 <1401245361.5049.6.camel@cyc>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 May 2014 09:53:35 -0700
Message-ID: <1401296015.4361.12.camel@oc3432500282.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052816-6688-0000-0000-000002277850
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-28 at 10:49 +0800, Chen Yucong wrote:
> > From: Borislav Petkov <bp@suse.de>
> > 
> > Hi all,
> > 
> > this is something Tony and I have been working on behind the curtains
> > recently. Here it is in a RFC form, it passes quick testing in kvm. Let
> > me send it out before I start hammering on it on a real machine.
> > 
> > More indepth info about what it is and what it does is in patch 1/3.
> > 
> > As always, comments and suggestions are most welcome.
> > 
> > Thanks.
> 
> What's the point of this patch set?
> My understanding is that if there are some(COUNT_MASK) corrected DRAM
> ECC errors for a specific page frame, we can believe that the page frame
> is so ill that it should be isolated as soon as possible.
> 
> The question is: memory_failure can not be used for isolating the page
> frame which is being used by kernel, because it just poison the page and
> IGNORED. memory_failure is mostly used for handling AR/AO type errors
> related to the page frame which the userspace tasks are using now.
> 
> Although the relative page frame is very ill, it is not dead and can
> still work. However, memory_failure may kill the userspace tasks,
> especially for those page frames that are holding dynamic data rather
> than file-backed(file/swap) data.
> 
> So I do not think that it is a good idea to directly use memory_failure
> in this patch set. 
> 

I second that. You can't poison a page and potentially kill an
application just because an arbitrarily chosen number of corrected
errors has been exceeded. That would be an anti-RAS feature: less
reliability and availability.
A possible alternative would be to soft-offline the page. This is
currently done in APEI code when corrected memory error thresholds are
exceeded and reported by UEFI via a generic hardware error source
(GHES). 
The example is in ghes_handle_memory_failure() where we call
memory_failure_queue(pfn, 0, flags) with flags = MF_SOFT_OFFLINE

- Max

