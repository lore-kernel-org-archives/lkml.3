Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbaJVRLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 13:11:50 -0400
Received: from mail-bn1on0115.outbound.protection.outlook.com ([157.56.110.115]:50123
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753631AbaJVRLs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 13:11:48 -0400
X-Greylist: delayed 933 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Oct 2014 13:11:47 EDT
From: KY Srinivasan <kys@microsoft.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] tools: hv: introduce -n/--no-daemon option
Thread-Topic: [PATCH] tools: hv: introduce -n/--no-daemon option
Thread-Index: AQHP7hJHU31NkSJHnECxRR5x3GsLjZw8VTbw
Date: Wed, 22 Oct 2014 16:55:59 +0000
Message-ID: <9c8f6d2d85664e68a9a97a94e34c5393@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1413994031-25957-1-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1413994031-25957-1-git-send-email-vkuznets@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [2001:4898:80e8:ed31::3]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0710;UriScan:;
x-forefront-prvs: 037291602B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(13464003)(189002)(199003)(51704005)(377454003)(76576001)(87936001)(97736003)(2501002)(106356001)(77096002)(2656002)(108616004)(40100003)(101416001)(64706001)(106116001)(20776003)(4396001)(1511001)(99396003)(120916001)(107046002)(76482002)(19580395003)(21056001)(95666004)(99286002)(19580405001)(2421001)(85306004)(85852003)(86362001)(31966008)(92566001)(2561002)(80022003)(46102003)(50986999)(105586002)(33646002)(86612001)(76176999)(74316001)(122556002)(54356999)(3826002)(24736002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0710;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0597;
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Wednesday, October 22, 2014 9:07 AM
> To: KY Srinivasan; Haiyang Zhang; devel@linuxdriverproject.org
> Cc: linux-kernel@vger.kernel.org
> Subject: [PATCH] tools: hv: introduce -n/--no-daemon option
> 
> All tools/hv daemons do mandatory daemon() on startup. However, no
> pidfile is created, this make it difficult for an init system to track such
> daemons.
> Modern linux distros use systemd as their init system. It can handle the
> daemonizing by itself, however, it requires a daemon to stay in foreground
> for that. Some distros already carry distro-specific patch for hv tools which
> switches off daemon().
> 
> Introduce -n/--no-daemon option for all 3 daemons in hv/tools. Parse
> options with getopt() to make this part easily expandable.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
You may want to include Greg KH in the "to" list.
Signed-off-by:  K. Y. Srinivasan <kys@microsoft.com>


> ---
>  tools/hv/hv_fcopy_daemon.c | 33 +++++++++++++++++++++++++++++++-
> -
>  tools/hv/hv_kvp_daemon.c   | 34
> ++++++++++++++++++++++++++++++++--
>  tools/hv/hv_vss_daemon.c   | 33 +++++++++++++++++++++++++++++++--
>  3 files changed, 94 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/hv/hv_fcopy_daemon.c b/tools/hv/hv_fcopy_daemon.c
> index 8f96b3e..f437d73 100644
> --- a/tools/hv/hv_fcopy_daemon.c
> +++ b/tools/hv/hv_fcopy_daemon.c
> @@ -33,6 +33,7 @@
>  #include <sys/stat.h>
>  #include <fcntl.h>
>  #include <dirent.h>
> +#include <getopt.h>
> 
>  static int target_fd;
>  static char target_fname[W_MAX_PATH];
> @@ -126,15 +127,43 @@ static int hv_copy_cancel(void)
> 
>  }
> 
> -int main(void)
> +void print_usage(char *argv[])
> +{
> +	fprintf(stderr, "Usage: %s [options]\n"
> +		"Options are:\n"
> +		"  -n, --no-daemon        stay in foreground, don't
> daemonize\n"
> +		"  -h, --help             print this help\n", argv[0]);
> +}
> +
> +int main(int argc, char *argv[])
>  {
>  	int fd, fcopy_fd, len;
>  	int error;
> +	int daemonize = 1, long_index = 0, opt;
>  	int version = FCOPY_CURRENT_VERSION;
>  	char *buffer[4096 * 2];
>  	struct hv_fcopy_hdr *in_msg;
> 
> -	if (daemon(1, 0)) {
> +	static struct option long_options[] = {
> +		{"help",	no_argument,	   0,  'h' },
> +		{"no-daemon",	no_argument,	   0,  'n' },
> +		{0,		0,		   0,  0   }
> +	};
> +
> +	while ((opt = getopt_long(argc, argv, "hn", long_options,
> +				  &long_index)) != -1) {
> +		switch (opt) {
> +		case 'n':
> +			daemonize = 0;
> +			break;
> +		case 'h':
> +		default:
> +			print_usage(argv);
> +			exit(EXIT_FAILURE);
> +		}
> +	}
> +
> +	if (daemonize && daemon(1, 0)) {
>  		syslog(LOG_ERR, "daemon() failed; error: %s",
> strerror(errno));
>  		exit(EXIT_FAILURE);
>  	}
> diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c index
> 4088b81..22b0764 100644
> --- a/tools/hv/hv_kvp_daemon.c
> +++ b/tools/hv/hv_kvp_daemon.c
> @@ -43,6 +43,7 @@
>  #include <fcntl.h>
>  #include <dirent.h>
>  #include <net/if.h>
> +#include <getopt.h>
> 
>  /*
>   * KVP protocol: The user mode component first registers with the @@ -
> 1417,7 +1418,15 @@ netlink_send(int fd, struct cn_msg *msg)
>  	return sendmsg(fd, &message, 0);
>  }
> 
> -int main(void)
> +void print_usage(char *argv[])
> +{
> +	fprintf(stderr, "Usage: %s [options]\n"
> +		"Options are:\n"
> +		"  -n, --no-daemon        stay in foreground, don't
> daemonize\n"
> +		"  -h, --help             print this help\n", argv[0]);
> +}
> +
> +int main(int argc, char *argv[])
>  {
>  	int fd, len, nl_group;
>  	int error;
> @@ -1435,9 +1444,30 @@ int main(void)
>  	struct hv_kvp_ipaddr_value *kvp_ip_val;
>  	char *kvp_recv_buffer;
>  	size_t kvp_recv_buffer_len;
> +	int daemonize = 1, long_index = 0, opt;
> +
> +	static struct option long_options[] = {
> +		{"help",	no_argument,	   0,  'h' },
> +		{"no-daemon",	no_argument,	   0,  'n' },
> +		{0,		0,		   0,  0   }
> +	};
> +
> +	while ((opt = getopt_long(argc, argv, "hn", long_options,
> +				  &long_index)) != -1) {
> +		switch (opt) {
> +		case 'n':
> +			daemonize = 0;
> +			break;
> +		case 'h':
> +		default:
> +			print_usage(argv);
> +			exit(EXIT_FAILURE);
> +		}
> +	}
> 
> -	if (daemon(1, 0))
> +	if (daemonize && daemon(1, 0))
>  		return 1;
> +
>  	openlog("KVP", 0, LOG_USER);
>  	syslog(LOG_INFO, "KVP starting; pid is:%d", getpid());
> 
> diff --git a/tools/hv/hv_vss_daemon.c b/tools/hv/hv_vss_daemon.c index
> 6a213b8..9ae2b6e 100644
> --- a/tools/hv/hv_vss_daemon.c
> +++ b/tools/hv/hv_vss_daemon.c
> @@ -36,6 +36,7 @@
>  #include <linux/hyperv.h>
>  #include <linux/netlink.h>
>  #include <syslog.h>
> +#include <getopt.h>
> 
>  static struct sockaddr_nl addr;
> 
> @@ -131,7 +132,15 @@ static int netlink_send(int fd, struct cn_msg *msg)
>  	return sendmsg(fd, &message, 0);
>  }
> 
> -int main(void)
> +void print_usage(char *argv[])
> +{
> +	fprintf(stderr, "Usage: %s [options]\n"
> +		"Options are:\n"
> +		"  -n, --no-daemon        stay in foreground, don't
> daemonize\n"
> +		"  -h, --help             print this help\n", argv[0]);
> +}
> +
> +int main(int argc, char *argv[])
>  {
>  	int fd, len, nl_group;
>  	int error;
> @@ -143,8 +152,28 @@ int main(void)
>  	struct hv_vss_msg *vss_msg;
>  	char *vss_recv_buffer;
>  	size_t vss_recv_buffer_len;
> +	int daemonize = 1, long_index = 0, opt;
> +
> +	static struct option long_options[] = {
> +		{"help",	no_argument,	   0,  'h' },
> +		{"no-daemon",	no_argument,	   0,  'n' },
> +		{0,		0,		   0,  0   }
> +	};
> +
> +	while ((opt = getopt_long(argc, argv, "hn", long_options,
> +				  &long_index)) != -1) {
> +		switch (opt) {
> +		case 'n':
> +			daemonize = 0;
> +			break;
> +		case 'h':
> +		default:
> +			print_usage(argv);
> +			exit(EXIT_FAILURE);
> +		}
> +	}
> 
> -	if (daemon(1, 0))
> +	if (daemonize && daemon(1, 0))
>  		return 1;
> 
>  	openlog("Hyper-V VSS", 0, LOG_USER);
> --
> 1.9.3

