Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964788AbaCSKp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 06:45:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933777AbaCSKpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 06:45:24 -0400
Date: Wed, 19 Mar 2014 11:45:15 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: acme@ghostprotocols.net, LKML <linux-kernel@vger.kernel.org>,
        jmario@redhat.com, fowles@inreach.com, eranian@google.com
Subject: Re: [PATCH 02/19] perf, sort:  Add physid sorting based on mmap2 data
Message-ID: <20140319104515.GA7423@krava.brq.redhat.com>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
 <1393609388-40489-3-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393609388-40489-3-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 28, 2014 at 12:42:51PM -0500, Don Zickus wrote:

SNIP

> +static int64_t
> +sort__physid_cmp(struct hist_entry *left, struct hist_entry *right)
> +{
> +        u64 l, r;
> +        struct map *l_map = left->mem_info->daddr.map;
> +        struct map *r_map = right->mem_info->daddr.map;
> +
> +	/* store all NULL mem maps at the bottom */
> +	/* shouldn't even need this check, should have stubs */
> +	if (!left->mem_info->daddr.map || !right->mem_info->daddr.map)
> +		return 1;
> +
> +        /* group event types together */
> +        if (left->cpumode > right->cpumode) return -1;
> +        if (left->cpumode < right->cpumode) return 1;
> +
> +        if (l_map->maj > r_map->maj) return -1;
> +        if (l_map->maj < r_map->maj) return 1;
> +
> +        if (l_map->min > r_map->min) return -1;
> +        if (l_map->min < r_map->min) return 1;
> +
> +        if (l_map->ino > r_map->ino) return -1;
> +        if (l_map->ino < r_map->ino) return 1;
> +
> +        if (l_map->ino_generation > r_map->ino_generation) return -1;
> +        if (l_map->ino_generation < r_map->ino_generation) return 1;
> +
> +        /*
> +         * Addresses with no major/minor numbers are assumed to be
> +         * anonymous in userspace.  Sort those on pid then address.
> +         *
> +         * The kernel and non-zero major/minor mapped areas are
> +         * assumed to be unity mapped.  Sort those on address then pid.
> +         */
> +
> +        /* al_addr does all the right addr - start + offset calculations */
> +        l = left->mem_info->daddr.al_addr;
> +        r = right->mem_info->daddr.al_addr;
> +
> +        if (l_map->maj || l_map->min || l_map->ino || l_map-> ino_generation) {
> +                /* mmapped areas */
> +
> +                /* hack to mark similar regions, 'right' is new entry */
> +                /* entries with same maj/min/ino/inogen are in same address space */
> +                right->color = TRUE;
> +
> +                if (l > r) return -1;
> +                if (l < r) return 1;
> +
> +                /* sorting by iaddr makes calculations easier later */
> +                if (left->mem_info->iaddr.al_addr > right->mem_info->iaddr.al_addr) return -1;
> +                if (left->mem_info->iaddr.al_addr < right->mem_info->iaddr.al_addr) return 1;
> +
> +                if (left->thread->pid_ > right->thread->pid_) return -1;
> +                if (left->thread->pid_ < right->thread->pid_) return 1;
> +
> +                if (left->thread->tid > right->thread->tid) return -1;
> +                if (left->thread->tid < right->thread->tid) return 1;
> +        } else if (left->cpumode == PERF_RECORD_MISC_KERNEL) {
> +                /* kernel mapped areas where 'start' doesn't matter */
> +
> +                /* hack to mark similar regions, 'right' is new entry */
> +                /* whole kernel region is in the same address space */
> +                right->color = TRUE;
> +
> +                if (l > r) return -1;
> +                if (l < r) return 1;
> +
> +                /* sorting by iaddr makes calculations easier later */
> +                if (left->mem_info->iaddr.al_addr > right->mem_info->iaddr.al_addr) return -1;
> +                if (left->mem_info->iaddr.al_addr < right->mem_info->iaddr.al_addr) return 1;
> +
> +                if (left->thread->pid_ > right->thread->pid_) return -1;
> +                if (left->thread->pid_ < right->thread->pid_) return 1;
> +
> +                if (left->thread->tid > right->thread->tid) return -1;
> +                if (left->thread->tid < right->thread->tid) return 1;
> +        } else {
> +                /* userspace anonymous */
> +                if (left->thread->pid_ > right->thread->pid_) return -1;
> +                if (left->thread->pid_ < right->thread->pid_) return 1;
> +
> +                if (left->thread->tid > right->thread->tid) return -1;
> +                if (left->thread->tid < right->thread->tid) return 1;
> +
> +	         /* hack to mark similar regions, 'right' is new entry */
> +                /* userspace anonymous address space is contained within pid */
> +                right->color = TRUE;
> +
> +                if (l > r) return -1;
> +                if (l < r) return 1;
> +
> +                /* sorting by iaddr makes calculations easier later */
> +                if (left->mem_info->iaddr.al_addr > right->mem_info->iaddr.al_addr) return -1;
> +                if (left->mem_info->iaddr.al_addr < right->mem_info->iaddr.al_addr) return 1;
> +        }

do you need single column for 'physid' ?

my first idea was to have separate sort entries for all checked entries:
(same way like for memory memory_sort_dimensions)

  - mem_info->daddr.al_addr (we already have 'addr' check)
  - mem_info->iaddr.al_addr
  - thread->pid_ (we have only 'tid' check so far)
  - l_map->maj, l_map->min, l_map->ino, l_map, ino_generation (we could probably group these)

and init sort order with:

   sort_order = "physid,pid,...";

'...' is whatever name you choose for above entries


you can check the sort entries cmp function call
logic in hist_entry__cmp function

jirka
