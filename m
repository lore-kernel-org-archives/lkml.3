Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbaDQICb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 04:02:31 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:48746 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbaDQICZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 04:02:25 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-5b-534f8a8f9572
From: Chao Yu <chao2.yu@samsung.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <000c01cf5a06$46b1ba30$d4152e90$@samsung.com>
 <1397719003.7727.24.camel@kjgkr>
In-reply-to: <1397719003.7727.24.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH] f2fs: fix wrong number of max_nid when init
Date: Thu, 17 Apr 2014 16:01:20 +0800
Message-id: <000001cf5a13$5d8d6620$18a83260$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQG0grNzbJuH4NjWUfUifVzHm9WULgJF5GkHmzjsrrA=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9jAd3+Lv9gg/8vjCyu7/rLZHFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyjg6dSZbwV++iqPN
	3A2M37m7GDk4JARMJC73SHcxcgKZYhIX7q1n62Lk4hASWMQo8a2zhxXC+cEo8f/8GlaQKjYB
	FYnlHf+ZQGwRAWmJWZ/msYDYzAKZEveaZjCD2EICMRK9ryeAxTkFdCXav34H6xUW8JaY8+YO
	WC+LgKrEjq9v2EFsXgFLidbuV4wQtqDEj8n3oGaqS0yat4gZwtaWePLuAivEpQoSO86+ZoS4
	wUri7f8v7BA14hIbj9ximcAoNAvJqFlIRs1CMmoWkpYFjCyrGEVTC5ILipPScw31ihNzi0vz
	0vWS83M3MYLD/pnUDsaVDRaHGAU4GJV4eCeo+wcLsSaWFVfmHmKU4GBWEuGNrgUK8aYkVlal
	FuXHF5XmpBYfYpTmYFES5z3Qah0oJJCeWJKanZpakFoEk2Xi4JRqYJxldUZnV9+/5Fv3Tq3r
	iOQ+8nibYccN+aJOw3W71L2CHgp5F0lM0j2ruvX4mcs8ixvfyuTFrhSIcrlxb+ZM0fkaMxTc
	GC4XhUga/K1TM/JPD9eL+7huzcESiXkyEQk9h8VidURN3yUyZE3ljHP4LV3/bdZFG80Tf7U2
	3j4RsLu78OtDnzjzBiWW4oxEQy3mouJEAEf/L/J3AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> Sent: Thursday, April 17, 2014 3:17 PM
> To: Chao Yu
> Cc: linux-f2fs-devel@lists.sourceforge.net; linux-fsdevel@vger.kernel.org;
> linux-kernel@vger.kernel.org
> Subject: Re: [f2fs-dev] [PATCH] f2fs: fix wrong number of max_nid when init
> 
> Hi,
> 
> 2014-04-17 (목), 14:27 +0800, Chao Yu:
> > Since max_nid value was minus three in previous commit:
> > 'b63da15e8b475245026bdf2096853683f189706b', Our last three nids could not be
> > used ever, but 0/node nid/meta nid is still occupied.
> > And also our ra_meta_pages() could not readahead the last block of NAT.
> 
> What is the root problem in there?

The last one is the root problem, I will submit another patch to fix it.

> IIRC, the max_nid should not be turned back since that can cause an
> infinite loop during build_free_nids() under a test using whole the
> nids.

Got it, thanks for your explanation.

Regards.

> 
> > Let's fix the wrong calculation of this value, and left the reserved nids there.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/node.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > index 84f9b7b..3f0bb50 100644
> > --- a/fs/f2fs/node.c
> > +++ b/fs/f2fs/node.c
> > @@ -1860,7 +1860,7 @@ static int init_node_manager(struct f2fs_sb_info *sbi)
> >  	nat_blocks = nat_segs << le32_to_cpu(sb_raw->log_blocks_per_seg);
> >
> >  	/* not used nids: 0, node, meta, (and root counted as valid node) */
> > -	nm_i->max_nid = NAT_ENTRY_PER_BLOCK * nat_blocks - 3;
> > +	nm_i->max_nid = NAT_ENTRY_PER_BLOCK * nat_blocks;
> >  	nm_i->fcnt = 0;
> >  	nm_i->nat_cnt = 0;
> >  	nm_i->ram_thresh = DEF_RAM_THRESHOLD;
> 
> --
> Jaegeuk Kim
> Samsung

