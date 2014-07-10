Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbaGJVJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:09:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:6614 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbaGJVJh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:09:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,639,1400050800"; 
   d="scan'208";a="571358558"
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Daniel Vetter <daniel@ffwll.ch>, Paolo Bonzini <pbonzini@redhat.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Chen, Tiejun" <tiejun.chen@intel.com>,
        "Kay, Allen M" <allen.m.kay@intel.com>
Subject: RE: [Intel-gfx] [RFC][PATCH] gpu:drm:i915:intel_detect_pch: back to
 check devfn instead of check class type
Thread-Topic: [Intel-gfx] [RFC][PATCH] gpu:drm:i915:intel_detect_pch: back
 to check devfn instead of check class type
Thread-Index: AQHPmhLtddRUcHA0YU245zC1cQ8wppuZzrXA
Date: Thu, 10 Jul 2014 21:08:24 +0000
Message-ID: <AADFC41AFE54684AB9EE6CBC0274A5D125FCA7FF@SHSMSX101.ccr.corp.intel.com>
References: <1403171631-3452-1-git-send-email-tiejun.chen@intel.com>
 <53A42DAA.80406@redhat.com> <53A692F9.3060200@intel.com>
 <53AA70C0.2000806@redhat.com> <20140707144917.GZ5821@phenom.ffwll.local>
 <53BAB569.5000709@redhat.com> <20140707175402.GS5821@phenom.ffwll.local>
 <53BADFC6.9060101@redhat.com> <20140707184006.GU5821@phenom.ffwll.local>
In-Reply-To: <20140707184006.GU5821@phenom.ffwll.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Daniel Vetter
> Sent: Monday, July 07, 2014 11:40 AM
> 
> On Mon, Jul 07, 2014 at 07:58:30PM +0200, Paolo Bonzini wrote:
> > Il 07/07/2014 19:54, Daniel Vetter ha scritto:
> > >On Mon, Jul 07, 2014 at 04:57:45PM +0200, Paolo Bonzini wrote:
> > >>Il 07/07/2014 16:49, Daniel Vetter ha scritto:
> > >>>So the correct fix to forward intel gpus to guests is indeed to somehow
> > >>>fake the pch pci ids since the driver really needs them. Gross design, but
> > >>>that's how the hardware works.
> > >>
> > >>A way that could work for virtualization is this: if you find the card has a
> > >>magic subsystem vendor id, fetch the subsystem device id and use _that_
> as
> > >>the PCH device id.
> > >>
> > >>Would that work for you?
> > >
> > >I guess for quemu it also depends upon what windows does since we can't
> > >change that. If we care about that part. Another consideration is
> > >supporting older kernels, if that's possible at all.
> >
> > Yes, but right now it's more important to get something that's not too gross
> > for the future, for both Linux and Windows.  Hacks for existing guests can
> > be done separately, especially since they might differ between Linux (check
> > ISA bridge) and Windows (check 1f.0).
> 
> Well old Linux also checked 1f.0, so kinda the same really. As long as
> 1f.0 is an isa bridge. Wrt Windows I don't really expect them to change
> this (they're probably more focuesed on the windows hypervisor or whatever).

discussion is also on-going with Windows driver folks. Add Allen here.

> 
> In the end if the approach is ok for quemu and isn't much worse than what
> we currently have I don't mind at all about the i915.ko code. I just want
> to avoid flip-flopping around on the hack du jour like we seem to do just
> now.
> -Daniel

actually I'm curious whether it's still necessary to __detect__ PCH. Could
we assume a 1:1 mapping between GPU and PCH, e.g. BDW already hard
code the knowledge:

              } else if (IS_BROADWELL(dev)) {
                      dev_priv->pch_type = PCH_LPT;
                      dev_priv->pch_id =
                              INTEL_PCH_LPT_LP_DEVICE_ID_TYPE;
                      DRM_DEBUG_KMS("This is Broadwell, assuming "
                                    "LynxPoint LP PCH\n");

Or if there is real usage on non-fixed mapping (not majority), could it be a 
better option to have fixed mapping as a fallback instead of leaving as 
PCH_NONE? Then even when Qemu doesn't provide a special tweaked PCH,
the majority case just works.

Thanks
Kevin
