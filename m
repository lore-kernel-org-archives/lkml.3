Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbaJBQrO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:47:14 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59285 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbaJBQrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:47:13 -0400
Date: Thu, 2 Oct 2014 09:46:57 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davem@davemloft.net,
        ebiederm@xmission.com, akpm@linux-foundation.org, adobriyan@gmail.com,
        rui.xiang@huawei.com, viro@zeniv.linux.org.uk, oleg@redhat.com,
        gorcunov@openvz.org, kirill.shutemov@linux.intel.com,
        grant.likely@secretlab.ca, tytso@mit.edu,
        Thierry Herbelot <thierry.herbelot@6wind.com>
Subject: Re: [RFC PATCH linux 2/2] fs/proc: use a hash table for the
 directory entries
Message-ID: <20141002094657.1e28e027@urahara>
In-Reply-To: <1412263501-6572-3-git-send-email-nicolas.dichtel@6wind.com>
References: <20131003.150947.2179820478039260398.davem@davemloft.net>
	<1412263501-6572-1-git-send-email-nicolas.dichtel@6wind.com>
	<1412263501-6572-3-git-send-email-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  2 Oct 2014 17:25:01 +0200
Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:

> From: Thierry Herbelot <thierry.herbelot@6wind.com>
> 
> The current implementation for the directories in /proc is using a single
> linked list. This is slow when handling directories with large numbers of
> entries (eg netdevice-related entries when lots of tunnels are opened).
> 
> This patch enables multiple linked lists. A hash based on the entry name is
> used to select the linked list for one given entry.
> 
> The speed creation of netdevices is faster as shorter linked lists must be
> scanned when adding a new netdevice.
> 
> Here are some numbers:
> 
> dummy30000.batch contains 30 000 times 'link add type dummy'.
> 
> Before the patch:
> time ip -b dummy30000.batch
> real    2m32.221s
> user    0m0.380s
> sys     2m30.610s
> 
> After the patch:
> time ip -b dummy30000.batch
> real    1m57.190s
> user    0m0.350s
> sys     1m56.120s
> 
> The single 'subdir' list head is replaced by a subdir hash table. The subdir
> hash buckets are only allocated for directories. The number of hash buckets
> is a compile-time parameter.
> 
> For all functions which handle directory entries, an additional check on the
> directory nature of the dir entry ensures that pde_hash_buckets was allocated.
> This check was not needed as subdir was present for all dir entries, whether
> actual directories or simple files.
> 
> Signed-off-by: Thierry Herbelot <thierry.herbelot@6wind.com>
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

I think the speed up is a good idea and makes sense.
It would be better to use exist hlist macros for hash table rather than
open coding it.
