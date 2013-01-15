Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887Ab3AOTPa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 14:15:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064Ab3AOTP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 14:15:28 -0500
Message-ID: <50F5AACB.7000303@redhat.com>
Date: Tue, 15 Jan 2013 11:15:23 -0800
From: Josh Stone <jistone@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Anton Arapov <anton@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Frank Eigler <fche@redhat.com>
Subject: Re: [RFC PATCH 5/6] uprobes: add bp_vaddr argument to consumer handler
References: <1356088596-17858-1-git-send-email-anton@redhat.com> <1356088596-17858-6-git-send-email-anton@redhat.com> <20121222163545.GE18082@redhat.com> <20121222171329.GA20691@redhat.com> <20121223154910.GA7106@redhat.com> <20130108142715.GA16849@bandura.brq.redhat.com> <50EF43F8.3040403@redhat.com> <20130112170655.GA20945@redhat.com>
In-Reply-To: <20130112170655.GA20945@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2013 09:06 AM, Oleg Nesterov wrote:
> On 01/10, Josh Stone wrote:
>> and for uretprobes we want the original return address.
> 
> Yes, Anton's v2 does this.
> 
> But. Don't you also need to know the address of function we are going
> to return from?
> 
> Probably you do not, uprobe_consumer should know which function (but
> not vaddr) it probes, but please confirm.

Right, this is fine.

The main reason we need a fixed-up IP is to have a consistent user state
for unwinding and evaluating other related DWARF expressions.

Setting regs->ip to the entry address of the function we just returned
from would actually be harmful, as it would be completely lying about
the current execution point, and the rest of the register and memory
state wouldn't match that point either.

Maybe it would be useful if regs->ip reflected the address of the RET
instruction we just executed, but only if e.g. regs->sp also got rewound
accordingly.  Since I don't think this is possible, just setting
regs->ip to the return target is good enough.

Josh
