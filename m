Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591AbaEUDgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 23:36:55 -0400
Received: from mail.kernel.org ([198.145.19.201]:46316 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbaEUDgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 23:36:53 -0400
Message-ID: <1400643406.12240.6.camel@kjgkr>
Subject: Re: [f2fs-dev] [PATCH] f2fs: avoid crash when trace
 f2fs_submit_page_mbio event in ra_sum_pages
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Chao Yu <chao2.yu@samsung.com>
Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Date: Wed, 21 May 2014 12:36:46 +0900
In-Reply-To: <005801cf70e7$66cb0090$346101b0$@samsung.com>
References: <005801cf70e7$66cb0090$346101b0$@samsung.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-KRDYOVaXrfDKNEFiWIQU"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KRDYOVaXrfDKNEFiWIQU
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Chao,

2014-05-16 (=EA=B8=88), 17:14 +0800, Chao Yu:
> Previously we allocate pages with no mapping in ra_sum_pages(), so we may
> encounter a crash in event trace of f2fs_submit_page_mbio where we access
> mapping data of the page.
>=20
> We'd better allocate pages in bd_inode mapping and invalidate these pages=
 after
> we restore data from pages. It could avoid crash in above scenario.
>=20
> Call Trace:
>  [<f1031630>] ? ftrace_raw_event_f2fs_write_checkpoint+0x80/0x80 [f2fs]
>  [<f10377bb>] f2fs_submit_page_mbio+0x1cb/0x200 [f2fs]
>  [<f103c5da>] restore_node_summary+0x13a/0x280 [f2fs]
>  [<f103e22d>] build_curseg+0x2bd/0x620 [f2fs]
>  [<f104043b>] build_segment_manager+0x1cb/0x920 [f2fs]
>  [<f1032c85>] f2fs_fill_super+0x535/0x8e0 [f2fs]
>  [<c115b66a>] mount_bdev+0x16a/0x1a0
>  [<f102f63f>] f2fs_mount+0x1f/0x30 [f2fs]
>  [<c115c096>] mount_fs+0x36/0x170
>  [<c1173635>] vfs_kern_mount+0x55/0xe0
>  [<c1175388>] do_mount+0x1e8/0x900
>  [<c1175d72>] SyS_mount+0x82/0xc0
>  [<c16059cc>] sysenter_do_call+0x12/0x22
>=20
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/node.c |   49 ++++++++++++++++++++++++++++---------------------
>  1 file changed, 28 insertions(+), 21 deletions(-)
>=20
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 3d60d3d..b5cd814 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1658,13 +1658,16 @@ int recover_inode_page(struct f2fs_sb_info *sbi, =
struct page *page)
> =20
>  /*
>   * ra_sum_pages() merge contiguous pages into one bio and submit.
> - * these pre-readed pages are linked in pages list.
> + * these pre-readed pages are alloced in bd_inode's mapping tree.
>   */
> -static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *page=
s,
> +static int ra_sum_pages(struct f2fs_sb_info *sbi, struct page **pages,
>  				int start, int nrpages)
>  {
>  	struct page *page;
> +	struct inode *inode =3D sbi->sb->s_bdev->bd_inode;
> +	struct address_space *mapping =3D inode->i_mapping;
>  	int page_idx =3D start;
> +	int alloced, readed;
>  	struct f2fs_io_info fio =3D {
>  		.type =3D META,
>  		.rw =3D READ_SYNC | REQ_META | REQ_PRIO
> @@ -1672,21 +1675,23 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi,=
 struct list_head *pages,
> =20
>  	for (; page_idx < start + nrpages; page_idx++) {
>  		/* alloc temporal page for read node summary info*/
> -		page =3D alloc_page(GFP_F2FS_ZERO);
> +		page =3D grab_cache_page(mapping, page_idx);
>  		if (!page)
>  			break;
> -
> -		lock_page(page);
> -		page->index =3D page_idx;
> -		list_add_tail(&page->lru, pages);
> +		page_cache_release(page);

IMO, we don't need to do like this.
Instead,
	for() {
		page =3D grab_cache_page();
		if (!page)
			break;
		page[page_idx] =3D page;
		f2fs_submit_page_mbio(sbi, page, &fio);
	}
	f2fs_submit_merged_bio(sbi, META, READ);
	return page_idx - start;

Afterwards, in restore_node_summry(),
	lock_page() will wait the end_io for read.
	...
	f2fs_put_page(pages[index], 1);

Thanks,

>  	}
> =20
> -	list_for_each_entry(page, pages, lru)
> -		f2fs_submit_page_mbio(sbi, page, page->index, &fio);
> +	alloced =3D page_idx - start;
> +	readed =3D find_get_pages_contig(mapping, start, alloced, pages);
> +	BUG_ON(alloced !=3D readed);
> +
> +	for (page_idx =3D 0; page_idx < readed; page_idx++)
> +		f2fs_submit_page_mbio(sbi, pages[page_idx],
> +					pages[page_idx]->index, &fio);
> =20
>  	f2fs_submit_merged_bio(sbi, META, READ);
> =20
> -	return page_idx - start;
> +	return readed;
>  }
> =20
>  int restore_node_summary(struct f2fs_sb_info *sbi,
> @@ -1694,11 +1699,11 @@ int restore_node_summary(struct f2fs_sb_info *sbi=
,
>  {
>  	struct f2fs_node *rn;
>  	struct f2fs_summary *sum_entry;
> -	struct page *page, *tmp;
> +	struct inode *inode =3D sbi->sb->s_bdev->bd_inode;
>  	block_t addr;
>  	int bio_blocks =3D MAX_BIO_BLOCKS(max_hw_blocks(sbi));
> -	int i, last_offset, nrpages, err =3D 0;
> -	LIST_HEAD(page_list);
> +	struct page *pages[bio_blocks];
> +	int i, index, last_offset, nrpages, err =3D 0;
> =20
>  	/* scan the node segment */
>  	last_offset =3D sbi->blocks_per_seg;
> @@ -1709,29 +1714,31 @@ int restore_node_summary(struct f2fs_sb_info *sbi=
,
>  		nrpages =3D min(last_offset - i, bio_blocks);
> =20
>  		/* read ahead node pages */
> -		nrpages =3D ra_sum_pages(sbi, &page_list, addr, nrpages);
> +		nrpages =3D ra_sum_pages(sbi, pages, addr, nrpages);
>  		if (!nrpages)
>  			return -ENOMEM;
> =20
> -		list_for_each_entry_safe(page, tmp, &page_list, lru) {
> +		for (index =3D 0; index < nrpages; index++) {
>  			if (err)
>  				goto skip;
> =20
> -			lock_page(page);
> -			if (unlikely(!PageUptodate(page))) {
> +			lock_page(pages[index]);
> +			if (unlikely(!PageUptodate(pages[index]))) {
>  				err =3D -EIO;
>  			} else {
> -				rn =3D F2FS_NODE(page);
> +				rn =3D F2FS_NODE(pages[index]);
>  				sum_entry->nid =3D rn->footer.nid;
>  				sum_entry->version =3D 0;
>  				sum_entry->ofs_in_node =3D 0;
>  				sum_entry++;
>  			}
> -			unlock_page(page);
> +			unlock_page(pages[index]);
>  skip:
> -			list_del(&page->lru);
> -			__free_pages(page, 0);
> +			page_cache_release(pages[index]);
>  		}
> +
> +		invalidate_mapping_pages(inode->i_mapping, addr,
> +							addr + nrpages);
>  	}
>  	return err;
>  }

--=20
Jaegeuk Kim

--=-KRDYOVaXrfDKNEFiWIQU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJTfB9OAAoJEEAUqH6CSFDSPu8P/iPyD5Oaye5bMapVkyaHnGQ7
NwoJXgwaz2Bc5Y6SBkNB2gv5Ubx2gGV32NIqiRgVRQOj7LESUNT128/ZVvgbMOgk
M3Y2n340YhyZJDK39psHxhRvhbe6AblCn3cSiyrDOchKYbeIRaE1od2AGKHoYgbZ
aQLaX1MucaV4bNBqII4VXolHykLaYofcJENCfZjE+CLFiO9dCtztjwvqO8RTXRkS
Y8zEeSnU0FY2iFAYvVcriVYOiQJ9LSo6Hb+PonwHEschtZjIgJFKlqvjBjJzCeHo
GEmEOQmZgwzUuSZ6wnqpsb5qoiVyN1uS2vE4jIJvP2i8lve1o/0WfhK0RCcaXrCw
TVJi5OyGS1bQc0YWR+gMG/7aijuh3vy7l5gWsNkM/nY+eWxFFXTi59BWIYzwQVHb
j9RIbEbVqCwxpaQW2vvPIyrG1XlLXss/E+bg9sUow5sKeuYKIN8PhYjCGBYS6QIB
MCZvHg0WWQGnirT1TgTBAp2vrkPnO2GLM3soUIPzuGV+KWbbGgQ5WjIYlwglXgxC
YkTpovdvBg353VCmh3QqAbsnxzIg9utA7KTHhiREsVSjKtJ1AFV7E3pCy0EW24Qz
Vbr7IsiMg+27RRAc+oRxhL1Jyz/y0Lh0+RL/jLdtDm7CFqIZ/upvzZ4tfdLRz+sX
q1TjpQbPEeB31eQbOqyv
=VsdX
-----END PGP SIGNATURE-----

--=-KRDYOVaXrfDKNEFiWIQU--

