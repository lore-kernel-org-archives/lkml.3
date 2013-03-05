Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab3CEW03 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:26:29 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:42762 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104Ab3CEW02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:26:28 -0500
Message-ID: <51367104.5050200@linux.vnet.ibm.com>
Date: Tue, 05 Mar 2013 14:26:12 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
CC: bp@alien8.de, hpa@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [3.9-rc1 x86] Bug in ioremap code?
References: <201302060035.GCJ00057.FLHMOOFtJFSQOV@I-love.SAKURA.ne.jp> <201303050015.GGI39081.LOVFtOFHQOJFSM@I-love.SAKURA.ne.jp> <201303052031.JFG81705.FSOOFQHJMVFOLt@I-love.SAKURA.ne.jp> <201303060041.AIF15342.tJFOHLQFFOMVSO@I-love.SAKURA.ne.jp> <20130305180650.GD4914@pd.tnic> <201303060628.CBG00578.OJtMFFHLQVSFOO@I-love.SAKURA.ne.jp>
In-Reply-To: <201303060628.CBG00578.OJtMFFHLQVSFOO@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030522-3620-0000-0000-0000017E2008
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just booted a qemu-kvm guest with this .config.  It didn't trip over
anything, so I'm looking for some more ACPI tables to feed in to it.

Looking through the code, it looks like this is the __pa() that's
hitting the BUG_ON():

static int __cpa_process_fault(struct cpa_data *cpa, unsigned long
...
        if (within(vaddr, PAGE_OFFSET,
                   PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT))) {
                cpa->numpages = 1;
                cpa->pfn = __pa(vaddr) >> PAGE_SHIFT;
                return 0;
        } else {

The within() check should ensure that we're not doing __pa() on
vmalloc() addresses.  So, either somebody managed to remap part of the
kernel identity mapping, or that within() check is failing us somehow.

What kind of hardware is this?

