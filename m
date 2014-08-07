Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbaHGTbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 15:31:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:42743 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbaHGTbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 15:31:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,819,1400050800"; 
   d="scan'208";a="555334936"
Message-ID: <53E3D3FF.70707@linux.intel.com>
Date: Thu, 07 Aug 2014 12:31:11 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Amit Shah <amit.shah@redhat.com>, jgarzik@bitpay.com
CC: Virtualization List <virtualization@lists.linux-foundation.org>,
        Amos Kong <akong@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
Subject: Re: [PATCH 1/2] rngd: add udev rule to source from hwrng if virtio-rng
 present
References: <cover.1407416628.git.amit.shah@redhat.com> <dd2ddb8458e5ab5cffceb7fac2e3f71e9e2197f3.1407416628.git.amit.shah@redhat.com>
In-Reply-To: <dd2ddb8458e5ab5cffceb7fac2e3f71e9e2197f3.1407416628.git.amit.shah@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2014 06:08 AM, Amit Shah wrote:
> On KVM guests where the virtio-rng device is available, and set as the
> current rng, this udev rule will start rngd which will feed in the
> host-provided entropy to /dev/random.
> 
> Signed-off-by: Amit Shah <amit.shah@redhat.com>
> ---
>  90-virtio-rng.rules | 1 +
>  1 file changed, 1 insertion(+)
>  create mode 100644 90-virtio-rng.rules
> 
> diff --git a/90-virtio-rng.rules b/90-virtio-rng.rules
> new file mode 100644
> index 0000000..07f2f9c
> --- /dev/null
> +++ b/90-virtio-rng.rules
> @@ -0,0 +1 @@
> +KERNEL=="hw_random", ATTR{rng_current}=="virtio*", RUN+="/sbin/rngd -r /dev/hwrng"
> 

I'm not sure this is really right.  rngd can receive input from a number
of sources, and I suspect it would be better to rngd to be started much
earlier and perhaps get sent a SIGHUP to reconfigure when a hw_random
device appears ... not just the virtio one.

Currently rngd exits if there is no daemon.  There are a few ways to
deal with that: one is to run rngd on changes and leave a pid file
around; the rngd can try to signal the old rngd or launch itself;
another option would be to have a different rngd for each source.  To
some degree the above is obsolete when we get khwrngd widely deployed,
but that is a new-kernel-only kind of thing.

	-hpa

