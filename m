Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab3AKICj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 03:02:39 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:48691 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab3AKICi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 03:02:38 -0500
Date: Fri, 11 Jan 2013 03:02:34 -0500 (EST)
From: Tomas Hozza <thozza@redhat.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: jasowang@redhat.com, Haiyang Zhang <haiyangz@microsoft.com>,
        linux-kernel@vger.kernel.org, Hashir Abdi <habdi@microsoft.com>,
        gregkh@linuxfoundation.org
Message-ID: <1986454953.1148002.1357891354839.JavaMail.root@redhat.com>
In-Reply-To: <d9ba1dfaa89f4605bdfa6fa3c71dbe68@SN2PR03MB061.namprd03.prod.outlook.com>
Subject: Re: [PATCH 1/2] tools: hv: Fix how ifcfg-* file is created
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.34.4.165]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a mistake in this Patch. Sorry for this.
I'll send corrected one ASAP after testing it!

----- Original Message -----
> 
> 
> > -----Original Message-----
> > From: Tomas Hozza [mailto:thozza@redhat.com]
> > Sent: Tuesday, January 08, 2013 6:27 AM
> > To: gregkh@linuxfoundation.org
> > Cc: KY Srinivasan; jasowang@redhat.com; Haiyang Zhang; linux-
> > kernel@vger.kernel.org; Hashir Abdi; Tomas Hozza
> > Subject: [PATCH 1/2] tools: hv: Fix how ifcfg-* file is created
> > 
> > Fix for the daemon code and for hv_set_ifconfig.sh script, so
> > that the created ifcfg-* file is consistent with initscripts
> > documentation.
> > 
> > Signed-off-by: Tomas Hozza <thozza@redhat.com>
> Acked-by: K. Y. Srinivasan <kys@microsoft.com>
> 
> > ---
> >  tools/hv/hv_kvp_daemon.c    | 73
> >  ++++++++++++++++++++++---------------------
> > --
> >  tools/hv/hv_set_ifconfig.sh | 22 ++++++--------
> >  2 files changed, 44 insertions(+), 51 deletions(-)
> > 
> > diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> > index d25a469..6b56b75 100644
> > --- a/tools/hv/hv_kvp_daemon.c
> > +++ b/tools/hv/hv_kvp_daemon.c
> > @@ -1162,16 +1162,13 @@ static int process_ip_string(FILE *f, char
> > *ip_string, int
> > type)
> >  				snprintf(str, sizeof(str), "%s", "DNS");
> >  				break;
> >  			}
> > -			if (i != 0) {
> > -				if (type != DNS) {
> > -					snprintf(sub_str, sizeof(sub_str),
> > -						"_%d", i++);
> > -				} else {
> > -					snprintf(sub_str, sizeof(sub_str),
> > -						"%d", ++i);
> > -				}
> > -			} else if (type == DNS) {
> > +
> > +			if (type == DNS) {
> >  				snprintf(sub_str, sizeof(sub_str), "%d", ++i);
> > +			} else if (type == GATEWAY && i == 0) {
> > +				++i;
> > +			} else {
> > +				snprintf(sub_str, sizeof(sub_str), "%d", i++);
> >  			}
> > 
> > 
> > @@ -1191,17 +1188,13 @@ static int process_ip_string(FILE *f, char
> > *ip_string, int
> > type)
> >  				snprintf(str, sizeof(str), "%s",  "DNS");
> >  				break;
> >  			}
> > -			if ((j != 0) || (type == DNS)) {
> > -				if (type != DNS) {
> > -					snprintf(sub_str, sizeof(sub_str),
> > -						"_%d", j++);
> > -				} else {
> > -					snprintf(sub_str, sizeof(sub_str),
> > -						"%d", ++i);
> > -				}
> > -			} else if (type == DNS) {
> > -				snprintf(sub_str, sizeof(sub_str),
> > -					"%d", ++i);
> > +
> > +			if (type == DNS) {
> > +				snprintf(sub_str, sizeof(sub_str), "%d", ++i);
> > +			} else if (j == 0) {
> > +				++j;
> > +			} else {
> > +				snprintf(sub_str, sizeof(sub_str), "_%d", j++);
> >  			}
> >  		} else {
> >  			return  HV_INVALIDARG;
> > @@ -1244,18 +1237,19 @@ static int kvp_set_ip_info(char *if_name,
> > struct
> > hv_kvp_ipaddr_value *new_val)
> >  	 * Here is the format of the ip configuration file:
> >  	 *
> >  	 * HWADDR=macaddr
> > -	 * IF_NAME=interface name
> > -	 * DHCP=yes (This is optional; if yes, DHCP is configured)
> > +	 * DEVICE=interface name
> > +	 * BOOTPROTO=<protocol> (where <protocol> is "dhcp" if DHCP is
> > configured
> > +	 *                       or "none" if no boot-time protocol
> > should be used)
> >  	 *
> > -	 * IPADDR=ipaddr1
> > -	 * IPADDR_1=ipaddr2
> > -	 * IPADDR_x=ipaddry (where y = x + 1)
> > +	 * IPADDR0=ipaddr1
> > +	 * IPADDR1=ipaddr2
> > +	 * IPADDRx=ipaddry (where y = x + 1)
> >  	 *
> > -	 * NETMASK=netmask1
> > -	 * NETMASK_x=netmasky (where y = x + 1)
> > +	 * NETMASK0=netmask1
> > +	 * NETMASKx=netmasky (where y = x + 1)
> >  	 *
> >  	 * GATEWAY=ipaddr1
> > -	 * GATEWAY_x=ipaddry (where y = x + 1)
> > +	 * GATEWAYx=ipaddry (where y = x + 1)
> >  	 *
> >  	 * DNSx=ipaddrx (where first DNS address is tagged as DNS1 etc)
> >  	 *
> > @@ -1294,20 +1288,23 @@ static int kvp_set_ip_info(char *if_name,
> > struct
> > hv_kvp_ipaddr_value *new_val)
> >  	if (error)
> >  		goto setval_error;
> > 
> > -	error = kvp_write_file(file, "IF_NAME", "", if_name);
> > +	error = kvp_write_file(file, "DEVICE", "", if_name);
> >  	if (error)
> >  		goto setval_error;
> > 
> > -	if (new_val->dhcp_enabled) {
> > -		error = kvp_write_file(file, "DHCP", "", "yes");
> > -		if (error)
> > -			goto setval_error;
> > +	if (new_val->dhcp_enabled)
> > +		error = kvp_write_file(file, "BOOTPROTO", "", "dhcp");
> > +	else
> > +		error = kvp_write_file(file, "BOOTPROTO", "", "none");
> > +
> > +	if (error)
> > +		goto setval_error;
> > +
> > +	/*
> > +	 * We are done!.
> > +	 */
> > +	goto setval_done;

This part is the problem. We should goto setval_done only
if we are using DHCP. Therefore now the IPADDR, NETMASK and
so on will not be in the generated ifcfg-* if not using DHCP!

> > 
> > -		/*
> > -		 * We are done!.
> > -		 */
> > -		goto setval_done;
> > -	}
> > 
> >  	/*
> >  	 * Write the configuration for ipaddress, netmask, gateway and
> > diff --git a/tools/hv/hv_set_ifconfig.sh
> > b/tools/hv/hv_set_ifconfig.sh
> > index 3e9427e..00b66be 100755
> > --- a/tools/hv/hv_set_ifconfig.sh
> > +++ b/tools/hv/hv_set_ifconfig.sh
> > @@ -20,18 +20,19 @@
> >  # Here is the format of the ip configuration file:
> >  #
> >  # HWADDR=macaddr
> > -# IF_NAME=interface name
> > -# DHCP=yes (This is optional; if yes, DHCP is configured)
> > +# DEVICE=interface name
> > +# BOOTPROTO=<protocol> (where <protocol> is "dhcp" if DHCP is
> > configured
> > +#                       or "none" if no boot-time protocol should
> > be used)
> >  #
> > -# IPADDR=ipaddr1
> > -# IPADDR_1=ipaddr2
> > -# IPADDR_x=ipaddry (where y = x + 1)
> > +# IPADDR0=ipaddr1
> > +# IPADDR1=ipaddr2
> > +# IPADDRx=ipaddry (where y = x + 1)
> >  #
> > -# NETMASK=netmask1
> > -# NETMASK_x=netmasky (where y = x + 1)
> > +# NETMASK0=netmask1
> > +# NETMASKx=netmasky (where y = x + 1)
> >  #
> >  # GATEWAY=ipaddr1
> > -# GATEWAY_x=ipaddry (where y = x + 1)
> > +# GATEWAYx=ipaddry (where y = x + 1)
> >  #
> >  # DNSx=ipaddrx (where first DNS address is tagged as DNS1 etc)
> >  #
> > @@ -53,11 +54,6 @@ echo "NM_CONTROLLED=no" >> $1
> >  echo "PEERDNS=yes" >> $1
> >  echo "ONBOOT=yes" >> $1
> > 
> > -dhcp=$(grep "DHCP" $1 2>/dev/null)
> > -if [ "$dhcp" != "" ];
> > -then
> > -echo "BOOTPROTO=dhcp" >> $1;
> > -fi
> > 
> >  cp $1 /etc/sysconfig/network-scripts/
> > 
> > --
> > 1.7.11.7
> > 
> > 
> 
> 
> 
