Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932858AbaLJSmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 13:42:09 -0500
Received: from mail-bn1on0132.outbound.protection.outlook.com ([157.56.110.132]:15681
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932501AbaLJSmH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 13:42:07 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, Dexuan Cui <decui@microsoft.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH] tools: hv: kvp_daemon: make IPv6-only-injection work
Thread-Topic: [PATCH] tools: hv: kvp_daemon: make IPv6-only-injection work
Thread-Index: AQHQE54V3s6Y4oFH5Ei19sKfQxDUY5yHOosIgAHvRWA=
Date: Wed, 10 Dec 2014 18:42:04 +0000
Message-ID: <BY2PR0301MB071140EB4894B98CC3A9AC29A0620@BY2PR0301MB0711.namprd03.prod.outlook.com>
References: <1418126489-20627-1-git-send-email-decui@microsoft.com>
 <877fy1ht1u.fsf@vitty.brq.redhat.com>
In-Reply-To: <877fy1ht1u.fsf@vitty.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4898:80e0:ee43::2]
x-microsoft-antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0776;
x-exchange-antispam-report-test: UriScan:;
x-exchange-antispam-report-cfa-test: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0776;
x-forefront-prvs: 0421BF7135
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(6009001)(13464003)(199003)(51704005)(377454003)(189002)(107046002)(122556002)(87936001)(120916001)(2656002)(64706001)(20776003)(40100003)(54606007)(99286002)(1511001)(99396003)(54356999)(50986999)(106116001)(105586002)(4396001)(76176999)(19580405001)(97736003)(106356001)(2421001)(74316001)(46102003)(54206007)(102836002)(86612001)(230783001)(2561002)(19580395003)(92566001)(62966003)(68736005)(77156002)(31966008)(76576001)(101416001)(21056001)(86362001)(33656002)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0776;H:BY2PR0301MB0711.namprd03.prod.outlook.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
> Sent: Tuesday, December 9, 2014 5:06 AM
> To: Dexuan Cui
> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com; KY Srinivasan; Haiyang Zhang
> Subject: Re: [PATCH] tools: hv: kvp_daemon: make IPv6-only-injection work
> 
> Dexuan Cui <decui@microsoft.com> writes:
> 
> > Currently IPv6-only-injection doesn't work because the daemon doesn't
> > parse any IPv6 information at all once it finds the dhcp_enabled flag is true.
> >
> > But according to the Hyper-v host team, the flag is only for IPv4.
> > In the case the host only injects 1 IPv6 address, the dhcp flag is
> > true, but we shouldn't ignore the IPv6 address and we should pass
> > BOOTPROTO=none to the distro-specific script hv_set_ipconfig.
> >
> > Tested in Ubuntu 14.10 and RHEL7.
> >
> > Cc: K. Y. Srinivasan <kys@microsoft.com>
> > Signed-off-by: Dexuan Cui <decui@microsoft.com>
> > ---
> >  tools/hv/hv_kvp_daemon.c | 47
> > +++++++++++++++++++++++++++++++----------------
> >  1 file changed, 31 insertions(+), 16 deletions(-)
> >
> > diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> index
> > 6a6432a..6ef6c04 100644
> > --- a/tools/hv/hv_kvp_daemon.c
> > +++ b/tools/hv/hv_kvp_daemon.c
> > @@ -1145,6 +1145,9 @@ static int kvp_write_file(FILE *f, char *s1,
> > char *s2, char *s3)  }
> >
> > +/* How many ipv6 addresses the host is trying to inject? */ static
> > +int num_ipv6_injected;
> > +
> >  static int process_ip_string(FILE *f, char *ip_string, int type)  {
> >  	int error = 0;
> > @@ -1190,6 +1193,7 @@ static int process_ip_string(FILE *f, char
> *ip_string, int type)
> >  			switch (type) {
> >  			case IPADDR:
> >  				snprintf(str, sizeof(str), "%s", "IPV6ADDR");
> > +				num_ipv6_injected++;
> >  				break;
> >  			case NETMASK:
> >  				snprintf(str, sizeof(str), "%s",
> "IPV6NETMASK"); @@ -1308,27
> > +1312,12 @@ static int kvp_set_ip_info(char *if_name, struct
> hv_kvp_ipaddr_value *new_val)
> >  	if (error)
> >  		goto setval_error;
> >
> > -	if (new_val->dhcp_enabled) {
> > -		error = kvp_write_file(file, "BOOTPROTO", "", "dhcp");
> > -		if (error)
> > -			goto setval_error;
> > -
> > -		/*
> > -		 * We are done!.
> > -		 */
> > -		goto setval_done;
> > -
> > -	} else {
> > -		error = kvp_write_file(file, "BOOTPROTO", "", "none");
> > -		if (error)
> > -			goto setval_error;
> > -	}
> > -
> >  	/*
> >  	 * Write the configuration for ipaddress, netmask, gateway and
> >  	 * name servers.
> >  	 */
> >
> > +	num_ipv6_injected = 0;
> >  	error = process_ip_string(file, (char *)new_val->ip_addr, IPADDR);
> >  	if (error)
> >  		goto setval_error;
> > @@ -1345,6 +1334,32 @@ static int kvp_set_ip_info(char *if_name, struct
> hv_kvp_ipaddr_value *new_val)
> >  	if (error)
> >  		goto setval_error;
> >
> > +	/*
> > +	 * Here "dhcp_enabled" is only for IPv4 according to Hyper-V host
> team.
> > +	 *
> > +	 * In the case the host only injects 1 IPv6 address:
> > +	 * new_val->dhcp_enabled is true, but we can't pass
> BOOTPROTO=dhcp to
> > +	 * the script hv_set_ifconfig, because in some distros (like RHEL7)
> > +	 * BOOTPROTO=dhcp has a special meaning in the config file (e.g.,
> > +	 * /etc/sysconfig/network-scripts/ifcfg-eth0): the network init
> program
> > +	 * ignores any static IP addr information once there is
> > +	 * BOOTPROTO=dhcp; as a result, IPv6-only injection can't work.
> > +	 *
> > +	 * In the case of IPv6-only injection, BOOTPROTO=dhcp doesn't
> affect
> > +	 * Ubuntu because it's ignored by the Ubuntu version of
> > +	 * hv_set_ifconfig and it doesn't seem to have special meaning in
> > +	 * Ubuntu.
> > +	 */
> 
> I just checked and adding "IPV6ADDR=something" when
> "BOOTPROTO=dhcp"
> works for me with both RHEL7 and Fedora21.
> 
> Other than that I think bringing distribution specifics into kernel.git is not a
> good idea. /etc/sysconfig/network-scripts/ifcfg-* format is distro-specific
> and not all Linux distros support it. Moreover, different distros can treat
> setting differently. I think it was wrong to stick to this format in kvp daemon
> from very beginning.
> 
> As a solution I would suggest doing the following: kvp daemon writes all
> received request details in distro-agnostic format in some temporary place
> and then calls distro-specific script to set things up. Actually, we already have
> such script: tools/hv/hv_set_ifconfig.sh
> 
> As for this bug I propose the following: remove skipping all IPADDR/MASK/...
> settings in case of "BOOTPROTO=dhcp" and let distro-specific script deal with
> the rest.

Vitaly, I agree that we should not have Distro specific code in the upstream kernel.
The idea was to create a file in the guest that reflected the data we got from the host
and have Distro specific scripts process this file. The current scripts under /hv/tools were
meant to be just example scripts that Distro vendors could use as a starting point.
I just chose to use RHEL for writing these example scripts.

K. Y
> 
> 
> > +	if (new_val->dhcp_enabled && num_ipv6_injected == 0) {
> > +		error = kvp_write_file(file, "BOOTPROTO", "", "dhcp");
> > +		if (error)
> > +			goto setval_error;
> > +	} else {
> > +		error = kvp_write_file(file, "BOOTPROTO", "", "none");
> > +		if (error)
> > +			goto setval_error;
> > +	}
> > +
> >  setval_done:
> >  	fclose(file);
> 
> --
>   Vitaly
