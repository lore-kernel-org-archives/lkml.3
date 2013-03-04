Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312Ab3CDPEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 10:04:52 -0500
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:58152 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757826Ab3CDPEv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 10:04:51 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.ucs.cam.ac.uk/email/scanner/
Subject: Re: cifs: bugfix for unreclaimed writeback pages in cifs_writev_requeue()
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=utf-8
From: Anton Altaparmakov <aia21@cam.ac.uk>
In-Reply-To: <20130302195530.6EACF6605DF@gitolite.kernel.org>
Date: Mon, 4 Mar 2013 15:04:49 +0000
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeff Layton <jlayton@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <F7FD7D54-C7FE-47E4-8741-FF56A3CC035A@cam.ac.uk>
References: <20130302195530.6EACF6605DF@gitolite.kernel.org>
To: Steve French <sfrench@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.1499)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The below commit that is present in 3.9-rc1 is buggy.  It releases the page at which point it may no longer exist and then it unlocks it afterwards.  Even if you are somehow getting away with it I think it is an explosion/memory corruption waiting to happen...

Best regards,

	Anton

On 2 Mar 2013, at 19:55, Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

> Gitweb:     http://git.kernel.org/linus/;a=commit;h=c51bb0ea40ca038da26b1fa7d450f4078124af03
> Commit:     c51bb0ea40ca038da26b1fa7d450f4078124af03
> Parent:     0b7bc84000d71f3647ca33ab1bf5bd928535c846
> Author:     Ouyang Maochun <ouyang.maochun@zte.com.cn>
> AuthorDate: Mon Feb 18 09:54:52 2013 -0600
> Committer:  Steve French <sfrench@us.ibm.com>
> CommitDate: Thu Feb 28 09:01:47 2013 -0600
> 
>    cifs: bugfix for unreclaimed writeback pages in cifs_writev_requeue()
> 
>    Pages get the PG_writeback flag set before cifs sends its
>    request to SMB server in cifs_writepages(), if the SMB service
>    goes down, cifs may try to recommit the writing requests in
>    cifs_writev_requeue(). However, it does not clean its PG_writeback
>    flag and relaimed the pages even if it fails again in
>    cifs_writev_requeue(), which may lead to the hanging of the
>    processes accessing the cifs directory. This patch just cleans
>    the PG_writeback flags and reclaims the pages under that circumstances.
> 
>        Steps to reproduce the bug(trying serveral times may trigger the issue):
>        1.Write from cifs client continuously.(e.g dd if=/dev/zero of=<cifs file>)
>        2.Stop SMB service from server.(e.g service smb stop)
>        3.Wait for two minutes， and then start SMB service from
>    server.(e.g service smb start)
>        4.The processes which are accessing cifs directory may hang up.
> 
>    Signed-off-by: Ouyang Maochun <ouyang.maochun@zte.com.cn>
>    Signed-off-by: Jiang Yong <jian.yong5@zte.com.cn>
>    Tested-by: Zhang Xianwei <zhang.xianwei8@zte.com.cn>
>    Reviewed-by: Wang Liang <wang.liang82@zte.com.cn>
>    Reviewed-by: Cai Qu <cai.qu@zte.com.cn>
>    Reviewed-by: Jiang Biao <jiang.biao2@zte.com.cn>
>    Reviewed-by: Jeff Layton <jlayton@redhat.com>
>    Reviewed-by: Pavel Shilovsky <piastry@etersoft.ru>
>    Signed-off-by: Steve French <sfrench@us.ibm.com>
> ---
> fs/cifs/cifssmb.c |    5 ++++-
> 1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 00e12f2..7353bc5 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -1909,8 +1909,11 @@ cifs_writev_requeue(struct cifs_writedata *wdata)
> 	} while (rc == -EAGAIN);
> 
> 	for (i = 0; i < wdata->nr_pages; i++) {
> -		if (rc != 0)
> +		if (rc != 0) {
> 			SetPageError(wdata->pages[i]);
> +			end_page_writeback(wdata->pages[i]);
> +			page_cache_release(wdata->pages[i]);
> +		}
> 		unlock_page(wdata->pages[i]);
> 	}
> 

-- 
Anton Altaparmakov <aia21 at cam.ac.uk> (replace at with @)
Unix Support, Computing Service, University of Cambridge, CB2 3QH, UK
Linux NTFS maintainer, http://www.linux-ntfs.org/

