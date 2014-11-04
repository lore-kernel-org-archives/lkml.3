Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbaKDCRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 21:17:34 -0500
Received: from mail-by2on0105.outbound.protection.outlook.com ([207.46.100.105]:40250
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751163AbaKDCRa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 21:17:30 -0500
From: Dexuan Cui <decui@microsoft.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH v3 RESEND] Tools: hv: vssdaemon: ignore the EBUSY on
 multiple freezing the same partition
Thread-Topic: [PATCH v3 RESEND] Tools: hv: vssdaemon: ignore the EBUSY on
 multiple freezing the same partition
Thread-Index: AQHP7QvtQ+R06uDVdE+EY9U8uNYDEpxPz+Zw
Date: Tue, 4 Nov 2014 02:16:50 +0000
Message-ID: <F792CF86EFE20D4AB8064279AFBA51C610587577@HKNPRD3002MB017.064d.mgd.msft.net>
References: <1413885374-12148-1-git-send-email-decui@microsoft.com>
In-Reply-To: <1413885374-12148-1-git-send-email-decui@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [141.251.55.133]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:131.107.125.37;CTRY:US;IPV:CAL;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(438002)(377454003)(199003)(51704005)(164054003)(189002)(13464003)(92726001)(107046002)(2656002)(2201001)(77156002)(86612001)(99396003)(16796002)(95666004)(86362001)(92566001)(46406003)(107886001)(31966008)(106116001)(86146001)(19580395003)(106466001)(19580405001)(46102003)(68736004)(77096003)(69596002)(87936001)(62966003)(76176999)(81156004)(50986999)(50466002)(120916001)(55846006)(26826002)(4396001)(84676001)(23726002)(2501002)(33656002)(54356999)(44976005)(66066001)(21056001)(6806004)(97736003)(20776003)(97756001)(64706001)(47776003)(309714004);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR0301MB0847;H:mail.microsoft.com;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR0301MB0847;
X-O365ENT-EOP-Header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
X-Forefront-PRVS: 03853D523D
Authentication-Results: spf=pass (sender IP is 131.107.125.37)
 smtp.mailfrom=decui@microsoft.com; 
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: devel [mailto:driverdev-devel-bounces@linuxdriverproject.org] On
> Behalf Of Dexuan Cui
> Sent: Tuesday, October 21, 2014 17:56 PM
> To: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Cc: Haiyang Zhang
> Subject: [PATCH v3 RESEND] Tools: hv: vssdaemon: ignore the EBUSY on
> multiple freezing the same partition
> 
> If a partition appears mounted more than once in /proc/mounts,
> vss_do_freeze()
> succeeds only for the first time and gets EBUSY (on freeze) or EINVAL (on
> thaw) for the second time. The patch ignores these to make the backup
> feature
> work.
> 
> Also improved the error handling in case a freeze operation fails.
> 
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
> 
> v2: Add "errno = 0;" before the ioctl()
> (Unnecessary and removed now since we remove syslog() in vss_do_freeze()
> in v3)
> 
> v3: Remove the unsafe syslog() in vss_do_freeze(): that could write the disk.
>     Thaw the filesystems in case the freezing operation fails.
>     In main(), add syslog() when we check the return value of vss_operate().
> 
> [Oct 21, 2014] This is just a RESEND since the previous one I sent about a
> month
> ago seems neglected. :-(
> 
>  tools/hv/hv_vss_daemon.c | 48
> ++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 40 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c
> index 6a213b8..1db9430 100644
> --- a/tools/hv/hv_vss_daemon.c
> +++ b/tools/hv/hv_vss_daemon.c
> @@ -44,21 +44,39 @@ static struct sockaddr_nl addr;
>  #endif
> 
> 
> -static int vss_do_freeze(char *dir, unsigned int cmd, char *fs_op)
> +/* Don't use syslog() in the function since that can cause write to disk */
> +static int vss_do_freeze(char *dir, unsigned int cmd)
>  {
>  	int ret, fd = open(dir, O_RDONLY);
> 
>  	if (fd < 0)
>  		return 1;
> +
>  	ret = ioctl(fd, cmd, 0);
> -	syslog(LOG_INFO, "VSS: %s of %s: %s\n", fs_op, dir, strerror(errno));
> +
> +	/*
> +	 * If a partition is mounted more than once, only the first
> +	 * FREEZE/THAW can succeed and the later ones will get
> +	 * EBUSY/EINVAL respectively: there could be 2 cases:
> +	 * 1) a user may mount the same partition to differnt directories
> +	 *  by mistake or on purpose;
> +	 * 2) The subvolume of btrfs appears to have the same partition
> +	 * mounted more than once.
> +	 */
> +	if (ret) {
> +		if ((cmd == FIFREEZE && errno == EBUSY) ||
> +		    (cmd == FITHAW && errno == EINVAL)) {
> +			close(fd);
> +			return 0;
> +		}
> +	}
> +
>  	close(fd);
>  	return !!ret;
>  }
> 
>  static int vss_operate(int operation)
>  {
> -	char *fs_op;
>  	char match[] = "/dev/";
>  	FILE *mounts;
>  	struct mntent *ent;
> @@ -68,11 +86,9 @@ static int vss_operate(int operation)
>  	switch (operation) {
>  	case VSS_OP_FREEZE:
>  		cmd = FIFREEZE;
> -		fs_op = "freeze";
>  		break;
>  	case VSS_OP_THAW:
>  		cmd = FITHAW;
> -		fs_op = "thaw";
>  		break;
>  	default:
>  		return -1;
> @@ -93,15 +109,23 @@ static int vss_operate(int operation)
>  			root_seen = 1;
>  			continue;
>  		}
> -		error |= vss_do_freeze(ent->mnt_dir, cmd, fs_op);
> +		error |= vss_do_freeze(ent->mnt_dir, cmd);
> +		if (error && operation == VSS_OP_FREEZE)
> +			goto err;
>  	}
>  	endmntent(mounts);
> 
>  	if (root_seen) {
> -		error |= vss_do_freeze("/", cmd, fs_op);
> +		error |= vss_do_freeze("/", cmd);
> +		if (error && operation == VSS_OP_FREEZE)
> +			goto err;
>  	}
> 
>  	return error;
> +err:
> +	endmntent(mounts);
> +	vss_operate(VSS_OP_THAW);
> +	return error;
>  }
> 
>  static int netlink_send(int fd, struct cn_msg *msg)
> @@ -249,8 +273,16 @@ int main(void)
>  		case VSS_OP_FREEZE:
>  		case VSS_OP_THAW:
>  			error = vss_operate(op);
> -			if (error)
> +			syslog(LOG_INFO, "VSS: op=%s: %s\n",
> +				op == VSS_OP_FREEZE ? "FREEZE" : "THAW",
> +				error ? "failed" : "succeeded");
> +
> +			if (error) {
>  				error = HV_E_FAIL;
> +				syslog(LOG_ERR, "op=%d failed!", op);
> +				syslog(LOG_ERR, "report it with these files:");
> +				syslog(LOG_ERR, "/etc/fstab and
> /proc/mounts");
> +			}
>  			break;
>  		default:
>  			syslog(LOG_ERR, "Illegal op:%d\n", op);
> --
> 1.9.1

Hi Greg,
ping. 
(I saw you replying in the lists 3 minutes ago. :-)

Thanks,
-- Dexuan
