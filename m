Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaFVRmQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 13:42:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:13197 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbaFVRmO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 13:42:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,524,1400050800"; 
   d="scan'208";a="532347913"
From: "Drokin, Oleg" <oleg.drokin@intel.com>
To: Fredrick John Berchmans <fredrickprashanth@gmail.com>
CC: "greg@kroah.com KH" <greg@kroah.com>,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        Tao Peng <tao.peng@emc.com>,
        "hpdd-discuss@lists.01.org" <hpdd-discuss@ml01.01.org>,
        "linux-kernel@vger.kernel.org Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: lustre use kernel socket sockopt apis
Thread-Topic: [PATCH] staging: lustre use kernel socket sockopt apis
Thread-Index: AQHPZqxKyhzvSkToDkeVTu7RFx4j+pt+KpgA
Date: Sun, 22 Jun 2014 17:42:12 +0000
Message-ID: <F77528EB-4244-4F2C-8C88-88F8CBF72EC7@intel.com>
References: <1399085415-2910-1-git-send-email-fredrickprashanth@gmail.com>
In-Reply-To: <1399085415-2910-1-git-send-email-fredrickprashanth@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.255.12.165]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D6BA61072C5FDE449FEA3940CF87AF5B@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I came back to this patch (now part of Greg's tree)

On May 2, 2014, at 10:50 PM, Fredrick John Berchmans wrote:

> Change old way of ops->setsockopt or ops->getsockopt in kernel
> to kernel_setsockopt or kernel_getsockopt.
> 
> --- a/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
> +++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-tcpip.c
> @@ -56,21 +56,8 @@ libcfs_sock_ioctl(int cmd, unsigned long arg)
> 		CERROR ("Can't create socket: %d\n", rc);
> 		return rc;
> 	}
> -
> -	sock_filp = sock_alloc_file(sock, 0, NULL);
> -	if (IS_ERR(sock_filp)) {
> -		sock_release(sock);
> -		rc = PTR_ERR(sock_filp);
> -		goto out;
> -	}
> -
> -	set_fs(KERNEL_DS);
> -	if (sock_filp->f_op->unlocked_ioctl)
> -		rc = sock_filp->f_op->unlocked_ioctl(sock_filp, cmd, arg);
> -	set_fs(oldmm);
> -
> -	fput(sock_filp);
> -out:
> +	rc = kernel_sock_ioctl(sock, cmd, arg);
> +	sock_release(sock);
> 	return rc;
> }

This part totally breaks lustre, we use this to also call things like SIOCGIFCONF that are not available from socket proto_ops because this is really coming from dev_ioctl and I do not see any better way to access it.
So I'd like this to be reverted or if there is a better way to access this, I am interested to learn it.

Bye,
    Oleg