Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbaEWFsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 01:48:33 -0400
Received: from mail.siteground.com ([67.19.240.234]:36284 "EHLO
	mail.siteground.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaEWFsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 01:48:32 -0400
Message-ID: <537EE129.1020603@1h.com>
Date: Fri, 23 May 2014 08:48:25 +0300
From: Marian Marinov <mm@1h.com>
Organization: 1H Ltd.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>, linux-kernel@vger.kernel.org
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biederman <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        lxc-devel@lists.linuxcontainers.org
Subject: Re: [RFC PATCH 11/11] loop: Allow priveleged operations for root
 in the namespace which owns a device
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com> <1400103299-144589-12-git-send-email-seth.forshee@canonical.com>
In-Reply-To: <1400103299-144589-12-git-send-email-seth.forshee@canonical.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - mail.siteground.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - 1h.com
X-Get-Message-Sender-Via: mail.siteground.com: none
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

One question about this patch.

Why don't you use the devices cgroup check if the root user in that namespace is allowed to use this device?

This way you can be sure that the root in that namespace can not access devices to which the host system did not gave
him access to.

Marian

On 05/15/2014 12:34 AM, Seth Forshee wrote:
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com> --- drivers/block/loop.c | 14 +++++++++----- 1 file
> changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/block/loop.c b/drivers/block/loop.c index 66bd938bcc1c..2cc19868ea0d 100644 ---
> a/drivers/block/loop.c +++ b/drivers/block/loop.c @@ -1074,7 +1074,7 @@ loop_set_status(struct loop_device *lo,
> const struct loop_info64 *info)
> 
> if (lo->lo_encrypt_key_size && !uid_eq(lo->lo_key_owner, uid) && -	    !capable(CAP_SYS_ADMIN)) +
> !ns_capable(disk_to_dev(lo->lo_disk)->ns, CAP_SYS_ADMIN)) return -EPERM; if (lo->lo_state != Lo_bound) return
> -ENXIO; @@ -1164,7 +1164,8 @@ loop_get_status(struct loop_device *lo, struct loop_info64 *info) 
> memcpy(info->lo_crypt_name, lo->lo_crypt_name, LO_NAME_SIZE); info->lo_encrypt_type = lo->lo_encryption ?
> lo->lo_encryption->number : 0; -	if (lo->lo_encrypt_key_size && capable(CAP_SYS_ADMIN)) { +	if
> (lo->lo_encrypt_key_size && +	    ns_capable(disk_to_dev(lo->lo_disk)->ns, CAP_SYS_ADMIN)) { 
> info->lo_encrypt_key_size = lo->lo_encrypt_key_size; memcpy(info->lo_encrypt_key, lo->lo_encrypt_key, 
> lo->lo_encrypt_key_size); @@ -1309,7 +1310,8 @@ static int lo_ioctl(struct block_device *bdev, fmode_t mode, 
> break; case LOOP_SET_STATUS: err = -EPERM; -		if ((mode & FMODE_WRITE) || capable(CAP_SYS_ADMIN)) +		if ((mode &
> FMODE_WRITE) || +		    ns_capable(disk_to_dev(lo->lo_disk)->ns, CAP_SYS_ADMIN)) err = loop_set_status_old(lo, 
> (struct loop_info __user *)arg); break; @@ -1318,7 +1320,8 @@ static int lo_ioctl(struct block_device *bdev,
> fmode_t mode, break; case LOOP_SET_STATUS64: err = -EPERM; -		if ((mode & FMODE_WRITE) || capable(CAP_SYS_ADMIN)) +
> if ((mode & FMODE_WRITE) || +		    ns_capable(disk_to_dev(lo->lo_disk)->ns, CAP_SYS_ADMIN)) err =
> loop_set_status64(lo, (struct loop_info64 __user *) arg); break; @@ -1327,7 +1330,8 @@ static int lo_ioctl(struct
> block_device *bdev, fmode_t mode, break; case LOOP_SET_CAPACITY: err = -EPERM; -		if ((mode & FMODE_WRITE) ||
> capable(CAP_SYS_ADMIN)) +		if ((mode & FMODE_WRITE) || +		    ns_capable(disk_to_dev(lo->lo_disk)->ns,
> CAP_SYS_ADMIN)) err = loop_set_capacity(lo, bdev); break; default:
> 


- -- 
Marian Marinov
Founder & CEO of 1H Ltd.
Jabber/GTalk: hackman@jabber.org
ICQ: 7556201
Mobile: +359 886 660 270
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlN+4SkACgkQ4mt9JeIbjJQMTACffYfr/7IGyjGU0DGnqxRJNMvv
3o4An06xvFTbINvXX9AYrM/gwTDL0GMt
=mlO7
-----END PGP SIGNATURE-----
