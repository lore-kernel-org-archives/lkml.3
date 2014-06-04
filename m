Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaFDQ4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:56:23 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:56162 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaFDQ4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:56:21 -0400
Date: Wed, 4 Jun 2014 18:56:14 +0200 (CEST)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@denkbrett
To: Tejun Heo <tj@kernel.org>
cc: Anatol Pomozov <anatol.pomozov@gmail.com>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org,
        Kent Overstreet <kmo@daterainc.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] percpu-refcount: fix usage of this_cpu_ops (was Re:
 hanging aio process)
In-Reply-To: <20140604161123.GG5004@htj.dyndns.org>
Message-ID: <alpine.LFD.2.11.1406041852220.1590@denkbrett>
References: <20140519180851.GD2915@kvack.org> <alpine.LFD.2.11.1405200950480.1606@denkbrett> <alpine.LFD.2.11.1405201508450.1606@denkbrett> <CAOMFOmWfQ2naF+1BE0wSQXpBoyxV6MPm021hY77B4sDpZNZ-Dw@mail.gmail.com> <alpine.LFD.2.11.1405201945280.1631@denkbrett>
 <CAOMFOmUT-WGbV57qDafM-NJ+=s1OzX-2Q6G6hAh6EV8Vt9yBZw@mail.gmail.com> <alpine.LFD.2.11.1405210954110.1579@denkbrett> <alpine.LFD.2.11.1405211042350.1579@denkbrett> <CAOMFOmXXHBicH38onWgVAWhEXe2sE_RMiJXi=iMjJB15o7mOLQ@mail.gmail.com>
 <alpine.LFD.2.11.1406041540520.21183@denkbrett> <20140604161123.GG5004@htj.dyndns.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
Organization: =?ISO-8859-15?Q?=22IBM_Deutschland_Research_&_Development_GmbH_=2F_Vorsitzende_des_Aufsichtsrats=3A_Martina_Koederitz_Gesch=E4ftsf=FChrung=3A_Dirk_Wittkopp_Sitz_der_Gesellschaft=3A_B=F6blingen_=2F_Registergericht?=
 =?ISO-8859-15?Q?=3A_Amtsgericht_Stuttgart=2C_HRB_243294=22?=
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060416-1948-0000-0000-00000010AE3D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 4 Jun 2014, Tejun Heo wrote:
> On Wed, Jun 04, 2014 at 03:58:24PM +0200, Sebastian Ott wrote:
> > From 82295633cad58c7d6b9af4e470e3168ed43a6779 Mon Sep 17 00:00:00 2001
> > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > Date: Wed, 4 Jun 2014 12:53:19 +0200
> > Subject: [PATCH] percpu-refcount: fix usage of this_cpu_ops
> > 
> > The percpu-refcount infrastructure uses the underscore variants of
> > this_cpu_ops in order to modify percpu reference counters.
> > (e.g. __this_cpu_inc()).
> > 
> > However the underscore variants do not atomically update the percpu
> > variable, instead they may be implemented using read-modify-write
> > semantics (more than one instruction).  Therefore it is only safe to
> > use the underscore variant if the context is always the same (process,
> > softirq, or hardirq). Otherwise it is possible to lose updates.
> > 
> > This problem is something that Sebastian has seen within the aio
> > subsystem which uses percpu refcounters both in process and softirq
> > context leading to reference counts that never dropped to zeroes; even
> > though the number of "get" and "put" calls matched.
> > 
> > Fix this by using the non-underscore this_cpu_ops variant which
> > provides correct per cpu atomic semantics and fixes the corrupted
> > reference counts.
> > 
> > Cc: Kent Overstreet <kmo@daterainc.com>
> > Cc: Tejun Heo <tj@kernel.org>
> > Cc: <stable@vger.kernel.org> # v3.11+
> > Reported-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
> > Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Bah... should have caught it way back.  Sorry about that.  Appying to
> percpu/for-3.15-fixes with stable cc'd.
> 

In your git tree you've used me as the patch author but that should be
Heiko. Sorry if I didn't annotate this correctly - I just inlined the
git format-patch output..

Thanks,
Sebastian

