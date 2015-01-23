Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbbAWMcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 07:32:18 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:52198 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753026AbbAWMcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 07:32:14 -0500
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
X-AuditID: cbfec7f4-b7f126d000001e9a-f1-54c23ebaab7d
Content-transfer-encoding: 8BIT
Message-id: <54C23F49.8040109@partner.samsung.com>
Date: Fri, 23 Jan 2015 15:32:09 +0300
From: Stefan Strogin <s.strogin@partner.samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.4.0
To: Gioh Kim <gioh.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: Stefan Strogin <stefan.strogin@gmail.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        aneesh.kumar@linux.vnet.ibm.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Pintu Kumar <pintu.k@samsung.com>,
        Weijie Yang <weijie.yang@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>, Hui Zhu <zhuhui@xiaomi.com>,
        Minchan Kim <minchan@kernel.org>, Dyasly Sergey <s.dyasly@samsung.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        s.strogin@partner.samsung.com
Subject: Re: [PATCH 2/3] mm: cma: introduce /proc/cmainfo
References: <cover.1419602920.git.s.strogin@partner.samsung.com>
 <264ce8ad192124f2afec9a71a2fc28779d453ba7.1419602920.git.s.strogin@partner.samsung.com>
 <xa1tzjaaz9f9.fsf@mina86.com> <54A160B6.5030605@gmail.com>
 <54A34E01.2050405@lge.com>
In-reply-to: <54A34E01.2050405@lge.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsVy+t/xy7q77A6FGPw4oWIxZ/0aNovHr+ex
	WDxr+sJosbK7mc1ie+cMdovOiUvYLS7vmsNmcW/Nf1aLtUfuslssON7CarHs63t2i77vh9kt
	Js+Wsvh2cg6zxeU3/9ktps74wW5xcsNZVosNzVwOQh6X+3qZPHbOusvuMbtjJqvHplWdbB6b
	Pk1i9+h6e4XJ48SM3yweDw5tZvFY9+cVk8fBd3uYPPq2rGL0+LxJzqNr4y/WAN4oLpuU1JzM
	stQifbsErozV10+wFUzhrzi36jhrA+NPri5GTg4JAROJqce6WSFsMYkL99azdTFycQgJLGWU
	aP6wjgkkwSsgKPFj8j2WLkYODmYBeYkjl7IhTHWJKVNyIco/Mkqc6NvBClFuJPF0xy8mkBoW
	AVWJL7OtQcJsQKuOXZjOCGKLCkRIzD/2mhnEFhEIlriw9yILyBxmgessEnNOHwNLCAtYSpzf
	tZkNxBYS+MIose+yEojNCbT30p6DLBMYBWYhuW4WwnWzEK5bwMi8ilE0tTS5oDgpPddQrzgx
	t7g0L10vOT93EyMkMr/sYFx8zOoQowAHoxIP746nB0OEWBPLiitzDzFKcDArifBaax4KEeJN
	SaysSi3Kjy8qzUktPsTIxMEp1cAouZpVNa9+Yoba/euMl1bFqhhv6U0X/Jsmeuf9zIpDK2c+
	12thu3vx5MRbFZy5awonTj7RfbXjj+PdqepLp6zYN3nVp+AXAX2d/z7OnlW63/0qJ5+N0bd/
	R43Vrge+PhnmFywq1pFgJmXwK+NM37L5GlITVJ+KbVy1YtGiBCn/BZah1kX1O/dGKbEUZyQa
	ajEXFScCAMemB6yqAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Gioh,

On 31/12/14 04:14, Gioh Kim wrote:
>
> Is it ok if the information is too big?
> I'm not sure but I remember that seq_printf has 4K limitation.

Thanks for reviewing, excuse me for a long delay.

If I understand correctly it is OK, since it's written in comments for
seq_has_overflowed():
>  * seq_files have a buffer which may overflow. When this happens a larger
>  * buffer is reallocated and all the data will be printed again.
>  * The overflow state is true when m->count == m->size.
And exactly this happens in traverse().

But I think that it's not important anymore as I intent not to use
seq_files in the second version.


>
> So I made seq_operations with seq_list_start/next functions.
>
> EX)
>
> static void *debug_seq_start(struct seq_file *s, loff_t *pos)
> {
> »       mutex_lock(&debug_lock);
> »       return seq_list_start(&debug_list, *pos);
> }   
>
> static void debug_seq_stop(struct seq_file *s, void *data)
> {
> »       struct debug_header *header = data;
>
> »       if (header == NULL || &header->head_list == &debug_list) {
> »       »       seq_printf(s, "end of info");
> »       }
>
> »       mutex_unlock(&debug_lock);
> }
>
> static void *debug_seq_next(struct seq_file *s, void *data, loff_t *pos)
> {
> »       return seq_list_next(data, &debug_list, pos);
> }
>
> static int debug_seq_show(struct seq_file *sfile, void *data)
> {
> »       struct debug_header *header;
> »       char *p;
>
> »       header= list_entry(data,
> »       »       »          struct debug_header,   
> »       »       »          head_list);
>
> »       seq_printf(sfile, "print info");
> »       return 0;
> }
> static const struct seq_operations debug_seq_ops = {
> »       .start = debug_seq_start,   
> »       .next = debug_seq_next,   
> »       .stop = debug_seq_stop,   
> »       .show = debug_seq_show,   
> };

