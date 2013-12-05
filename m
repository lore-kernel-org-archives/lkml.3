Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab3LECMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 21:12:37 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:53758 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab3LECMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 21:12:32 -0500
X-AuditID: cbfee61a-b7f796d000004313-9f-529fe10ef242
From: Chao Yu <chao2.yu@samsung.com>
To: "'???'" <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?gb2312?B?zLfmrQ==?= <shu.tan@samsung.com>
References: <001701cef15d$169a5a30$43cf0e90$@samsung.com>
In-reply-to: <001701cef15d$169a5a30$43cf0e90$@samsung.com>
Subject: RE: [f2fs-dev] [PATCH 3/3] f2fs: introduce f2fs_cache_node_page() to
 add page into node_inode cache
Date: Thu, 05 Dec 2013 10:10:59 +0800
Message-id: <001901cef15f$6fafea70$4f0fbf50$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQH+2kryUW6+L81HU0v0CZ/TiLWAhpnlCEkQ
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsVy+t9jQV2+h/ODDB5NNbK4vusvk8WlRe4W
	e/aeZLG4vGsOm0XrwvPMDqweuxd8ZvLo27KK0ePzJrkA5igum5TUnMyy1CJ9uwSujJXfbjIW
	PBOp6HjTw9LA+F+gi5GTQ0LARGLR6juMELaYxIV769m6GLk4hASmM0pcvPqNBcL5wSjx89VZ
	FpAqNgEVieUd/5lAbBEBZYlVHe1gHcwCMxglDs/9xwqSEBKwlPi/4C4biM0pYCWxdkozO4gt
	LJAncWnzZ7A4i4CqRGfLS7ChvED1P788ZoawBSV+TL4HFmcW0JDoX7SBDcKWl9i85i0zxKkK
	EjvOvmaEOMJI4s2tRnaIGnGJjUdusUxgFJqFZNQsJKNmIRk1C0nLAkaWVYyiqQXJBcVJ6bmG
	esWJucWleel6yfm5mxjBcfBMagfjygaLQ4wCHIxKPLwvEucHCbEmlhVX5h5ilOBgVhLhrb8K
	FOJNSaysSi3Kjy8qzUktPsQozcGiJM57oNU6UEggPbEkNTs1tSC1CCbLxMEp1cB4yO3qOibu
	pJB7/+ce+/PO/OwnHoG9nRxmp48fsj+6qGb78qOTtrpGmXD8/6oz9fO3Sim2z1LL/VfbVEY8
	ddm9ffPzR8tyLsSxzeNRnfWq+uuERost7ClNB9fNV77kpC9hZqoQlD7ZcJHgFte45Nun/Iy2
	qcYaytjf9HEKNTD3nr3KqWPPjGNHlViKMxINtZiLihMBcwx5wX8CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Chao Yu [mailto:chao2.yu@samsung.com]
> Sent: Thursday, December 05, 2013 9:55 AM
> To: ???
> Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
> Subject: [f2fs-dev] [PATCH 3/3] f2fs: introduce f2fs_cache_node_page() to add page into node_inode cache
> 
> This patch introduces f2fs_cache_node_page(), in this function, page which is
> readed ahead will be copy to node_inode's mapping cache.
> It will avoid rereading these node pages.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>

Suggested-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>

I miss that, my mistake.

> ---
>  fs/f2fs/node.c |   30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 099f06f..5e2588f 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1600,6 +1600,34 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
>  	return 0;
>  }
> 
> +/*
> + * f2fs_cache_node_page() copy updated page data to node_inode cache page.
> + */
> +void f2fs_cache_node_page(struct f2fs_sb_info *sbi, struct page *page,
> +						nid_t nid)
> +{
> +	struct address_space *mapping = sbi->node_inode->i_mapping;
> +	struct page *npage;
> +
> +	npage = find_get_page(mapping, nid);
> +	if (npage && PageUptodate(npage)) {
> +		f2fs_put_page(npage, 0);
> +		return;
> +	}
> +	f2fs_put_page(npage, 0);
> +
> +	npage = grab_cache_page(mapping, nid);
> +	if (!npage)
> +		return;
> +
> +	memcpy(page_address(npage), page_address(page), PAGE_CACHE_SIZE);
> +
> +	SetPageUptodate(npage);
> +	f2fs_put_page(npage, 1);
> +
> +	return;
> +}
> +
>  int restore_node_summary(struct f2fs_sb_info *sbi,
>  			unsigned int segno, struct f2fs_summary_block *sum)
>  {
> @@ -1633,6 +1661,8 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
>  				sum_entry->version = 0;
>  				sum_entry->ofs_in_node = 0;
>  				sum_entry++;
> +				f2fs_cache_node_page(sbi, page,
> +					le32_to_cpu(rn->footer.nid));
>  			} else {
>  				err = -EIO;
>  			}
> --
> 1.7.9.5
> 
> 
> ------------------------------------------------------------------------------
> Sponsored by Intel(R) XDK
> Develop, test and display web and hybrid apps with a single code base.
> Download it for free now!
> http://pubads.g.doubleclick.net/gampad/clk?id=111408631&iu=/4140/ostg.clktrk
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel

