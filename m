Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab3KFVS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 16:18:57 -0500
Received: from mout.gmx.net ([212.227.17.22]:62083 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932090Ab3KFVS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 16:18:56 -0500
Message-ID: <527AB23D.2060305@gmx.de>
Date: Wed, 06 Nov 2013 22:18:53 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Konstantin Khlebnikov <koct9i@gmail.com>
CC: Richard Weinberger <richard@nod.at>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        UML devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [uml-devel] fuzz tested 32 bit user mode linux image hangs in
 radix_tree_next_chunk()
References: <526696BF.6050909@gmx.de>	<CAFLxGvy3NeRKu+KQCCm0j4LS60PYhH0bC8WWjfiPvpstPBjAkA@mail.gmail.com>	<5266A698.10400@gmx.de>	<5266B60A.1000005@nod.at>	<52715AD1.7000703@gmx.de> <CALYGNiPvJF1u8gXNcX1AZR5-VkGqJnaose84KBbdaoBAq8aoGQ@mail.gmail.com>
In-Reply-To: <CALYGNiPvJF1u8gXNcX1AZR5-VkGqJnaose84KBbdaoBAq8aoGQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:87yiw3IOy6kOuwDw+iwNIj+SG06x+O9r0r6lD5MgjDu1rR4f6LD
 W7F4n33fSlaBa+mi3fYaLkzRUd4BcbTvTrCpfQSyXjzuIVYCjnQvN+PXJbXrmsjcWe3DokW
 KkhrwHw2lKucN0ZpGTsNALn8sNgobvMP6NTnb+uq3WFMt98Iyym5QdcTssQ/8OuSUFwSfGD
 7dP0F37lSFVWRW5eW5WJA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2013 05:06 PM, Konstantin Khlebnikov wrote:
> In this case it must stop after scanning whole tree in line:
> /* Overflow after ~0UL */
> if (!index)
>   return NULL;
> 

A fresh current example with latest git tree shows that lines 769 and 770 do alternate :


tfoerste@n22 ~/devel/linux $ sudo gdb /usr/local/bin/linux-v3.12-48-gbe408cd 16619 -n -batch -ex bt
0x08296a8c in radix_tree_next_chunk (root=0x25, iter=0x462e7c64, flags=12) at lib/radix-tree.c:770
770                                             if (node->slots[offset])
#0  0x08296a8c in radix_tree_next_chunk (root=0x25, iter=0x462e7c64, flags=12) at lib/radix-tree.c:770
#1  0x080cc1fe in find_get_pages (mapping=0x462ad470, start=0, nr_pages=14, pages=0xc) at mm/filemap.c:844
#2  0x080d5d6a in pagevec_lookup (pvec=0x462e7cc8, mapping=0x25, start=37, nr_pages=37) at mm/swap.c:914
#3  0x080d615a in truncate_inode_pages_range (mapping=0x462ad470, lstart=0, lend=-1) at mm/truncate.c:241
#4  0x080d64ff in truncate_inode_pages (mapping=0x25, lstart=51539607589) at mm/truncate.c:358




tfoerste@n22 ~/devel/linux $ sudo gdb /usr/local/bin/linux-v3.12-48-gbe408cd 16619 -n -batch -ex bt
radix_tree_next_chunk (root=0x28, iter=0x462e7c64, flags=18) at lib/radix-tree.c:769
769                                     while (++offset < RADIX_TREE_MAP_SIZE) {
#0  radix_tree_next_chunk (root=0x28, iter=0x462e7c64, flags=18) at lib/radix-tree.c:769
#1  0x080cc1fe in find_get_pages (mapping=0x462ad470, start=0, nr_pages=14, pages=0x12) at mm/filemap.c:844
#2  0x080d5d6a in pagevec_lookup (pvec=0x462e7cc8, mapping=0x28, start=40, nr_pages=40) at mm/swap.c:914
#3  0x080d615a in truncate_inode_pages_range (mapping=0x462ad470, lstart=0, lend=-1) at mm/truncate.c:241
#4  0x080d64ff in truncate_inode_pages (mapping=0x28, lstart=77309411368) at mm/truncate.c:358
#5  0x0825e388 in hostfs_evict_inode (inode=0x462ad3b8) at fs/hostfs/hostfs_kern.c:242
#6  0x0811a8df in evict (inode=0x462ad3b8) at fs/inode.c:549


-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
