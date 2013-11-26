Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852Ab3KZSdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:33:11 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:59802 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757108Ab3KZSdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:33:05 -0500
Message-ID: <5294E95C.7050902@linux.com>
Date: Tue, 26 Nov 2013 19:33:00 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peng Tao <bergwolf@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, Mikhail Pershin <mike.pershin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH v2 02/12] staging/lustre/llog: MGC to use OSD API for
 backup logs
References: <1385478286-5525-1-git-send-email-bergwolf@gmail.com> <1385478286-5525-3-git-send-email-bergwolf@gmail.com>
In-Reply-To: <1385478286-5525-3-git-send-email-bergwolf@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

just a few comments, mostly code style.

2013-11-26 16:04, Peng Tao:
> @@ -1011,23 +1083,17 @@ int mgc_set_info_async(const struct lu_env *env, struct obd_export *exp,
>  	}
>  	if (KEY_IS(KEY_SET_FS)) {
>  		struct super_block *sb = (struct super_block *)val;
> -		struct lustre_sb_info *lsi;
> +
>  		if (vallen != sizeof(struct super_block))
>  			return -EINVAL;
> -		lsi = s2lsi(sb);
> -		rc = mgc_fs_setup(exp->exp_obd, sb, lsi->lsi_srv_mnt);
> -		if (rc) {
> -			CERROR("set_fs got %d\n", rc);
> -		}
> +
> +		rc = mgc_fs_setup(exp->exp_obd, sb);
>  		return rc;

Why set rc when you return it on the next statement?
Wouldn't 'return mgc_fs_setup(exp->exp_obd, sb);' be better?

>  	}
>  	if (KEY_IS(KEY_CLEAR_FS)) {
>  		if (vallen != 0)
>  			return -EINVAL;
>  		rc = mgc_fs_cleanup(exp->exp_obd);
> -		if (rc) {
> -			CERROR("clear_fs got %d\n", rc);
> -		}
>  		return rc;

Same here possibly.

> +	/* Copy the setup log locally if we can. Don't mess around if we're
> +	 * running an MGS though (logs are already local). */
> +	if (lctxt && lsi && IS_SERVER(lsi) && !IS_MGS(lsi) &&
> +	    cli->cl_mgc_configs_dir != NULL &&
> +	    lu2dt_dev(cli->cl_mgc_configs_dir->do_lu.lo_dev) ==
> +	    lsi->lsi_dt_dev) {

I think that is *really* ugly!
(The last comparison is separated into two lines)

-- 
Regards,
Levente Kurusa
