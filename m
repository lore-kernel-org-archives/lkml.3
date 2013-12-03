Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab3LCNlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 08:41:55 -0500
Received: from smtp.citrix.com ([66.165.176.89]:23511 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752485Ab3LCNlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 08:41:51 -0500
X-IronPort-AV: E=Sophos;i="4.93,818,1378857600"; 
   d="scan'208";a="80082752"
Message-ID: <1386078108.13256.30.camel@kazak.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH RFC] xen-block: correctly define structures
 in public headers
From: Ian Campbell <Ian.Campbell@citrix.com>
To: David Vrabel <david.vrabel@citrix.com>
CC: Roger Pau Monne <roger.pau@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Julien Grall <julien.grall@linaro.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xenproject.org>,
        "Boris Ostrovsky" <boris.ostrovsky@oracle.com>
Date: Tue, 3 Dec 2013 13:41:48 +0000
In-Reply-To: <529DC7BA.7080506@citrix.com>
References: <1386068254-1413-1-git-send-email-roger.pau@citrix.com>
		 <529DBA07.6090108@citrix.com>
	 <1386068884.13256.9.camel@kazak.uk.xensource.com>
	 <529DC7BA.7080506@citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.80]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-03 at 11:59 +0000, David Vrabel wrote:
> On 03/12/13 11:08, Ian Campbell wrote:
> > On Tue, 2013-12-03 at 11:01 +0000, David Vrabel wrote:
> >> On 03/12/13 10:57, Roger Pau Monne wrote:
> >>> Using __packed__ on the public interface is not correct, this
> >>> structures should be compiled using the native ABI, and __packed__
> >>> should only be used in the backend counterpart of those structures
> >>> (which needs to handle different ABIs).
> >>>
> >>> This was even worse in the ARM case, where the Linux kernel was
> >>> incorrectly using the X86_32 protocol ABI. This patch fixes it, but
> >>> also breaks compatibility, so an ARM DomU kernel compiled with
> >>> this patch will fail to communicate with PV disk devices unless the
> >>> Dom0 also has this patch.
> >>
> >> This ABI change needs to be justified.  Why do you think it is
> >> acceptable to break existing Linux guests?  Because I don't think it is.
> > 
> > As I explained in my reply those guests are buggy.
> 
> The kernel has a strong policy on not changing ABIs, even to fix bugs.
> I don't think a bug fix alone is sufficient justification for ABI breakage.

This is not the kernels ABI to fix in stone. The ABI is defined by the
upstream Xen project and Linux has failed to follow the specified ABI
correctly.

> 1. The ARM ABI for blkif was specified as uniform between 32-bit and
> 64-bit and is equivalent to the x86_64 ABI.

The ARM ABI is specified here:
http://xenbits.xen.org/docs/unstable/hypercall/arm/include,public,arch-arm.h.html#incontents_arm_abi

> 2. ARM 32-bit back and frontend implementation did /not/ use this
> defined ABI, but instead used the x86_32 ABI.  What did 32-bit ARM
> frontends report as their ABI? x86_32? or native?

They reported themselves as ARM (XEN_IO_PROTO_ABI_ARM == "arm") but they
unintentionally implemented something else which was akin to the x86_32
API. They didn't actually "implement the x86_32 API", it's perhaps
confusing to say that they did.

> 3. ARM 64-bit back and frontend implementation did use the specified
> ABI, but the backend is not compatible with 32-bit ARM guests.  What did
> 64-bit ARM frontends report as their ABI?  x86_64? or native?

They report themselves as ARM (XEN_IO_PROTO_ABI_ARM == "arm").

> 4. Support for 64-bit ARM guests is not upstream in Linux yet (so I
> don't mind if 64-bit guests are broken).

Yes, it is upstream.

> I think this should be resolved in a backward compatible way.

No. Linux is in error here and should be fixed. We have done this before
(e.g. with event channels being the wrong bit size).

There is no deployed legacy of guests to support here. At this stage we
have not even formally committed to keeping the hypercall ABI stable. We
will likely do so with the Xen 4.4 release.

Ian.

