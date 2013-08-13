Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759093Ab3HMRcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 13:32:24 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:51236 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759021Ab3HMRcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 13:32:21 -0400
Message-ID: <520A6D98.9060204@linux.vnet.ibm.com>
Date: Tue, 13 Aug 2013 23:02:08 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>, tony.luck@intel.com,
        bhelgaas@google.com, rostedt@goodmis.org, rjw@sisk.pl,
        lance.ortiz@hp.com, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] mce: acpi/apei: trace: Enable ghes memory error trace
 event
References: <1375986471-27113-1-git-send-email-naveen.n.rao@linux.vnet.ibm.com> <1375986471-27113-4-git-send-email-naveen.n.rao@linux.vnet.ibm.com> <20130808163822.67e0828a@samsung.com> <20130810180322.GC4155@pd.tnic> <20130812083355.47c1bae8@samsung.com> <5208D80D.5030206@linux.vnet.ibm.com> <20130812125343.GE18018@pd.tnic> <520A16BD.30201@linux.vnet.ibm.com> <20130813124258.GC4077@pd.tnic>
In-Reply-To: <20130813124258.GC4077@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081317-6102-0000-0000-00000402E8E1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2013 06:12 PM, Borislav Petkov wrote:
> On Tue, Aug 13, 2013 at 04:51:33PM +0530, Naveen N. Rao wrote:
>> You're right - my trace point makes all the data provided by apei
>> as-is to userspace. However, ghes_edac seems to squash some of this
>> data into a string when reporting through mc_event.
>
> Right, for systems which don't need EDAC to decode to the DIMM or for
> which there are no EDAC drivers written, they could use a tracepoint
> which carries APEI info as-is. Others, which need EDAC, should probably
> use trace_mc_event and disable the APEI tracepoint.

If I'm not mistaken, even for systems that have EDAC drivers, it looks 
to me like EDAC can't really decode to the DIMM given what is provided 
by the bios in the APEI report currently. If and when ghes_edac gains 
this capability, users will have a choice between raw APEI reports vs. 
edac processed ones.

>
> I think this should address Tony's concerns...
>
> Btw, you could call your TP something simpler like
> trace_ghes_memory_event or so.

I started out with a simpler name, but eventually decided to use the 
name from the CPER record so it is clear what this event carries. I 
think this will be better when adding further ghes events for say, 
processor generic, PCIe and others.

>
> Btw 2, if GHES can report other types of errors (I'm pretty sure it can)
> maybe we can use a single tracepoint called trace_ghes_event for any
> types of errors coming out of it...

Two problems with this:
- One, the record size will be really big since the cper records for 
each type of error is large.
- Two, it may be better to filter events based on the type of error 
(memory error, processor, pcie, ...) rather than subscribing for all 
ghes error reports.

>
> Oh, and while at it, we probably need to start thinking of a mechanism
> to disable all the error printing, i.e. cper_print_mem() and such,
> if a userspace agent is listening in on the tracepoint and the error
> information is carried through it to userspace.

Do you mean conditionally print the cper records based on whether the 
tracepoint is enabled or not? Wouldn't that be confusing if someone is 
monitoring dmesg as well?


Thanks,
Naveen

