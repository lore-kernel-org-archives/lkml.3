Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759177Ab3EXAhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 20:37:25 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43637 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757915Ab3EXAhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 20:37:22 -0400
Message-ID: <1369355784.2080.5.camel@joe-AO722>
Subject: Re: [PATCH 1/1] x86/iommu: use bit structures for context_entry
From: Joe Perches <joe@perches.com>
To: "Li, Zhen-Hua" <zhen-hual@hp.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1369354931-19373-1-git-send-email-zhen-hual@hp.com>
References: <1369354931-19373-1-git-send-email-zhen-hual@hp.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 23 May 2013 17:36:24 -0700
Mime-Version: 1.0
X-Mailer: Evolution 3.6.4-0ubuntu1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-24 at 08:22 +0800, Li, Zhen-Hua wrote:
> There is a structure named context_entry used by intel iommu, and there
> are some bit operations on it. Use bit structure may make these operations
> easy.
[]
> diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
[]
> @@ -221,55 +221,28 @@ get_context_addr_from_root(struct root_entry *root)
>   * 8-23: domain id
>   */
>  struct context_entry {
> -	u64 lo;
> -	u64 hi;
> +	union {
> +		struct {
> +			u64	present:1,

why use struct and union at all?

Why not just:

struct context_entry {
	u64	present:1,
		fpd:1,
		translation_type:2,
		reserved_l:8,
		asr:52;
	u64	aw:3,
		avail:4,
		reserved_h1:1,
		did:16,
		reserved_h2:40;
}; 

> @@ -743,7 +716,8 @@ static void clear_context_table(struct intel_iommu *iommu, u8 bus, u8 devfn)
[]
>  	if (context) {
> -		context_clear_entry(&context[devfn]);
> +		context[devfn].lo = 0;
> +		context[devfn].hi = 0;

		memset(&context[devfn], 0, sizeof(...))


