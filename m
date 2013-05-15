Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756872Ab3EOKVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 06:21:15 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:49357 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754960Ab3EOKVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 06:21:13 -0400
X-IronPort-AV: E=Sophos;i="4.87,677,1363132800"; 
   d="scan'208";a="24132021"
Message-ID: <1368613266.11138.10.camel@hastur.hellion.org.uk>
Subject: Re: [Xen-devel] [PATCH-v2] xen: Don't call
 arch_trigger_all_cpu_backtrace in dom0(pvm)
From: Ian Campbell <ian.campbell@citrix.com>
To: <zhenzhong.duan@oracle.com>
CC: Jan Beulich <JBeulich@suse.com>, xen-devel <xen-devel@lists.xen.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tamon Shiose <tamon.shiose@oracle.com>, Feng Jin <joe.jin@oracle.com>
Date: Wed, 15 May 2013 11:21:06 +0100
In-Reply-To: <519349F1.8050607@oracle.com>
References: <51610A25.4010301@oracle.com>
	  <5162911202000078000CB38E@nat28.tlf.novell.com>
	 <1365525374.17014.22.camel@zakaz.uk.xensource.com>
	 <519349F1.8050607@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-15 at 16:40 +0800, Zhenzhong Duan wrote:
> On 2013-04-10 00:36, Ian Campbell wrote:
> > On Mon, 2013-04-08 at 08:42 +0100, Jan Beulich wrote:
> >>>>> On 07.04.13 at 07:54, Zhenzhong Duan <zhenzhong.duan@oracle.com> wrote:
> >>> nmi isn't supported in dom0, fallback to general all cpu backtrace code.
> >> Since when is sending NMIs not supported, and since when is this
> >> Dom0-specific? If you want to deal with this, you should do so
> >> properly: Special case sending NMIs in the respective Xen specific
> >> code (using VCPUOP_send_nmi), and carry this out in a way not
> >> dependent upon running (un)privileged.
> > You'd also need to implement the upcall support for receiving NMIs,
> > which IIRC isn't yet done for pvops.
> Hi Ian,
> 
> Could you give a suggestion on which file to change to support NMI upcall?
> I compare with vMCE code, made similar change.
> Use VCPUOP_send_nmi to send nmi between pvm guest vcpus, but nmi isn't 
> triggered.

You need to register a callback with CALLBACKOP_register
CALLBACKTYPE_nmi. You also need to write the code in entry.S to receive
that callback. IIRC you also need to arrange that returning from an NMI
is always done with HYPERVISOR_iret and not optimised to a direct iret
as it can be otherwise. This is to allow the hypervisor to implement NMI
masking correctly.

The linux-2.6.18-xen.hg tree implements NMI callbacks so you may find
inspiration there, although how upstreamable that approach is I'm not
sure. In particular stealing a EFLAGS bit to force the HYPERVISOR_iret
is certain to not be acceptable upstream.

Ian.

