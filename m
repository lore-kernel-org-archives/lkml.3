Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab3KFVbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 16:31:13 -0500
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752930Ab3KFVbL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 16:31:11 -0500
Message-ID: <527AB51B.1020005@nod.at>
Date: Wed, 06 Nov 2013 22:31:07 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
CC: Konstantin Khlebnikov <koct9i@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        UML devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: Re: [uml-devel] fuzz tested 32 bit user mode linux image hangs in
 radix_tree_next_chunk()
References: <526696BF.6050909@gmx.de>	<CAFLxGvy3NeRKu+KQCCm0j4LS60PYhH0bC8WWjfiPvpstPBjAkA@mail.gmail.com>	<5266A698.10400@gmx.de>	<5266B60A.1000005@nod.at>	<52715AD1.7000703@gmx.de> <CALYGNiPvJF1u8gXNcX1AZR5-VkGqJnaose84KBbdaoBAq8aoGQ@mail.gmail.com> <527AB23D.2060305@gmx.de>
In-Reply-To: <527AB23D.2060305@gmx.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 06.11.2013 22:18, schrieb Toralf Förster:
> On 11/06/2013 05:06 PM, Konstantin Khlebnikov wrote:
>> In this case it must stop after scanning whole tree in line:
>> /* Overflow after ~0UL */
>> if (!index)
>>   return NULL;
>>
> 
> A fresh current example with latest git tree shows that lines 769 and 770 do alternate :

Can you please ask gdb for the value of offset?

Thanks,
//richard

> 
> tfoerste@n22 ~/devel/linux $ sudo gdb /usr/local/bin/linux-v3.12-48-gbe408cd 16619 -n -batch -ex bt
> 0x08296a8c in radix_tree_next_chunk (root=0x25, iter=0x462e7c64, flags=12) at lib/radix-tree.c:770
> 770                                             if (node->slots[offset])
> #0  0x08296a8c in radix_tree_next_chunk (root=0x25, iter=0x462e7c64, flags=12) at lib/radix-tree.c:770
> #1  0x080cc1fe in find_get_pages (mapping=0x462ad470, start=0, nr_pages=14, pages=0xc) at mm/filemap.c:844
> #2  0x080d5d6a in pagevec_lookup (pvec=0x462e7cc8, mapping=0x25, start=37, nr_pages=37) at mm/swap.c:914
> #3  0x080d615a in truncate_inode_pages_range (mapping=0x462ad470, lstart=0, lend=-1) at mm/truncate.c:241
> #4  0x080d64ff in truncate_inode_pages (mapping=0x25, lstart=51539607589) at mm/truncate.c:358
> 
> 
> 
> 
> tfoerste@n22 ~/devel/linux $ sudo gdb /usr/local/bin/linux-v3.12-48-gbe408cd 16619 -n -batch -ex bt
> radix_tree_next_chunk (root=0x28, iter=0x462e7c64, flags=18) at lib/radix-tree.c:769
> 769                                     while (++offset < RADIX_TREE_MAP_SIZE) {
> #0  radix_tree_next_chunk (root=0x28, iter=0x462e7c64, flags=18) at lib/radix-tree.c:769
> #1  0x080cc1fe in find_get_pages (mapping=0x462ad470, start=0, nr_pages=14, pages=0x12) at mm/filemap.c:844
> #2  0x080d5d6a in pagevec_lookup (pvec=0x462e7cc8, mapping=0x28, start=40, nr_pages=40) at mm/swap.c:914
> #3  0x080d615a in truncate_inode_pages_range (mapping=0x462ad470, lstart=0, lend=-1) at mm/truncate.c:241
> #4  0x080d64ff in truncate_inode_pages (mapping=0x28, lstart=77309411368) at mm/truncate.c:358
> #5  0x0825e388 in hostfs_evict_inode (inode=0x462ad3b8) at fs/hostfs/hostfs_kern.c:242
> #6  0x0811a8df in evict (inode=0x462ad3b8) at fs/inode.c:549
> 
> 

