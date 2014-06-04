Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaFDQL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:11:29 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:51096 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbaFDQL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:11:27 -0400
Date: Wed, 4 Jun 2014 12:11:23 -0400
From: Tejun Heo <tj@kernel.org>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Anatol Pomozov <anatol.pomozov@gmail.com>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org,
        Kent Overstreet <kmo@daterainc.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] percpu-refcount: fix usage of this_cpu_ops (was Re:
 hanging aio process)
Message-ID: <20140604161123.GG5004@htj.dyndns.org>
References: <20140519180851.GD2915@kvack.org>
 <alpine.LFD.2.11.1405200950480.1606@denkbrett>
 <alpine.LFD.2.11.1405201508450.1606@denkbrett>
 <CAOMFOmWfQ2naF+1BE0wSQXpBoyxV6MPm021hY77B4sDpZNZ-Dw@mail.gmail.com>
 <alpine.LFD.2.11.1405201945280.1631@denkbrett>
 <CAOMFOmUT-WGbV57qDafM-NJ+=s1OzX-2Q6G6hAh6EV8Vt9yBZw@mail.gmail.com>
 <alpine.LFD.2.11.1405210954110.1579@denkbrett>
 <alpine.LFD.2.11.1405211042350.1579@denkbrett>
 <CAOMFOmXXHBicH38onWgVAWhEXe2sE_RMiJXi=iMjJB15o7mOLQ@mail.gmail.com>
 <alpine.LFD.2.11.1406041540520.21183@denkbrett>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1406041540520.21183@denkbrett>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 03:58:24PM +0200, Sebastian Ott wrote:
> From 82295633cad58c7d6b9af4e470e3168ed43a6779 Mon Sep 17 00:00:00 2001
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> Date: Wed, 4 Jun 2014 12:53:19 +0200
> Subject: [PATCH] percpu-refcount: fix usage of this_cpu_ops
> 
> The percpu-refcount infrastructure uses the underscore variants of
> this_cpu_ops in order to modify percpu reference counters.
> (e.g. __this_cpu_inc()).
> 
> However the underscore variants do not atomically update the percpu
> variable, instead they may be implemented using read-modify-write
> semantics (more than one instruction).  Therefore it is only safe to
> use the underscore variant if the context is always the same (process,
> softirq, or hardirq). Otherwise it is possible to lose updates.
> 
> This problem is something that Sebastian has seen within the aio
> subsystem which uses percpu refcounters both in process and softirq
> context leading to reference counts that never dropped to zeroes; even
> though the number of "get" and "put" calls matched.
> 
> Fix this by using the non-underscore this_cpu_ops variant which
> provides correct per cpu atomic semantics and fixes the corrupted
> reference counts.
> 
> Cc: Kent Overstreet <kmo@daterainc.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: <stable@vger.kernel.org> # v3.11+
> Reported-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Bah... should have caught it way back.  Sorry about that.  Appying to
percpu/for-3.15-fixes with stable cc'd.

Thanks.

-- 
tejun
