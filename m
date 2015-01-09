Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055AbbAIPuR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:50:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38286 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932413AbbAIPuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:50:16 -0500
Message-ID: <54AFF8B5.8050305@suse.cz>
Date: Fri, 09 Jan 2015 16:50:13 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Andy Lutomirski <luto@amacapital.net>
CC: "Kirill A. Shutemov" <kirill@shutemov.name>, Pavel Machek <pavel@ucw.cz>,
        Mark Seaborn <mseaborn@chromium.org>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: DRAM unreliable under specific access patern
References: <CAL82V5NN8U4PyiSjLxgpTrgsgkbM7rRCbVF5P-HHyEqphLOy+g@mail.gmail.com>	<20141224220818.GA17655@amd>	<20150105192329.5f32c155@lxorguk.ukuu.org.uk>	<CALCETrXby82sgbGTcSZFj54t=resYcwtPbcFRNh6Ksbr+Ow8HQ@mail.gmail.com>	<20150106014718.GA23775@node.dhcp.inet.fi>	<CALCETrV1O1MFJeY6WacF+QHdBGG7HoHdVQy=n951=Y+=g+h7mQ@mail.gmail.com>	<20150106021836.GA24121@node.dhcp.inet.fi>	<CALCETrXpJ7CPAKeh9nLA=PoCBT8w8NfhZg5cgUyG9BUtp2Jv+w@mail.gmail.com> <20150108130325.0592b18b@lxorguk.ukuu.org.uk>
In-Reply-To: <20150108130325.0592b18b@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2015 02:03 PM, One Thousand Gnomes wrote:
> On Mon, 5 Jan 2015 18:26:07 -0800
> Andy Lutomirski <luto@amacapital.net> wrote:
> 
> Thats less of a concern I think. As far as I can tell it would depend how
> the memory is wired what actually gets hit. I'm not clear if its within
> the range or not.
> 
>> > When I read the paper I thought that vdso would be interesting target for
>> > the attack, but having all these constrains in place, it's hard aim the
>> > attack anything widely used.
>> >
>> 
>> The vdso and the vvar page are both at probably-well-known physical
>> addresses, so you can at least target the kernel a little bit.  I
>> *think* that kASLR helps a little bit here.
> 
> SMEP likewise if you were able to use 1GB to corrupt matching lines
> elsewhere in RAM (eg the syscall table), but that would I think depend
> how the RAM is physically configured.
> 
> Thats why the large TLB case worries me. With 4K pages and to an extent
> with 2MB pages its actually quite hard to line up an attack if you know
> something about the target. With 1GB hugepages you control the lower bits
> of the physical address precisely. The question is whether that merely
> enables you to decide where to shoot yourself or it goes beyond that ?

I haven't read the details yet to judge if it's feasible in this case, but even
without hugepages, it's possible (albeit elaborately) to control physical
mapping from userspace. I've done this in the past, to have optimal mapping
(basically page coloring) to L2/L3 caches. It was done by allocating bunch of
memory, determining its physical addresses from /proc/self/pagemap, and then
rearanging it via mremap.

Then it's also quite trivial to induce cache misses without clflush, using just
few addresses that map to the same cache set, without having to cycle throuh
more memory than the cache size is.

But as I said, I haven't read the details here to see if the required access
pattern to corrupt ram can be combined with these kinds of tricks...

> (Outside HPC anyway: for HPC cases it bites both ways I suspect - you've
> got the ability to ensure you don't hit those access patterns while using
> 1GB pages, but also nothing to randomise stuff to make them unlikely if
> you happen to have worst case aligned data).
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

