Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab3AOTsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 14:48:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41683 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab3AOTsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 14:48:10 -0500
Message-ID: <50F5B214.5060604@zytor.com>
Date: Tue, 15 Jan 2013 11:46:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: [RFCv3][PATCH 1/3] create slow_virt_to_phys()
References: <20130109185904.DD641DCE@kernel.stglabs.ibm.com>
In-Reply-To: <20130109185904.DD641DCE@kernel.stglabs.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2013 10:59 AM, Dave Hansen wrote:
> +	switch (level) {
> +	case PG_LEVEL_4K:
> +		psize = PAGE_SIZE;
> +		pmask = PAGE_MASK;
> +		break;
> +	case PG_LEVEL_2M:
> +		psize = PMD_PAGE_SIZE;
> +		pmask = PMD_PAGE_MASK;
> +		break;
> +#ifdef CONFIG_X86_64
> +	case PG_LEVEL_1G:
> +		psize = PUD_PAGE_SIZE;
> +		pmask = PUD_PAGE_MASK;
> +		break;
> +#endif
> +	default:
> +		BUG();
> +	}

I object to this switch statement.  If we are going to create new 
primitives, let's create a primitive that embody this and put it in 
pgtypes_types.h, especially since it is simply an algorithmic operation:

static inline unsigned long page_level_size(int level)
{
	return (PAGE_SIZE/PGDIR_SIZE) << (PGDIR_SHIFT*level);
}
static inline unsigned long page_level_shift(int level)
{
	return (PAGE_SHIFT-PGDIR_SHIFT) + (PGDIR_SHIFT*level);
}

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

