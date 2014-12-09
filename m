Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbaLINGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:06:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755234AbaLINGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:06:03 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Dexuan Cui <decui@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com, kys@microsoft.com,
        haiyangz@microsoft.com
Subject: Re: [PATCH] tools: hv: kvp_daemon: make IPv6-only-injection work
References: <1418126489-20627-1-git-send-email-decui@microsoft.com>
Date: Tue, 09 Dec 2014 14:05:49 +0100
In-Reply-To: <1418126489-20627-1-git-send-email-decui@microsoft.com> (Dexuan
	Cui's message of "Tue, 9 Dec 2014 04:01:29 -0800")
Message-ID: <877fy1ht1u.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dexuan Cui <decui@microsoft.com> writes:

> Currently IPv6-only-injection doesn't work because the daemon doesn't parse
> any IPv6 information at all once it finds the dhcp_enabled flag is true.
>
> But according to the Hyper-v host team, the flag is only for IPv4.
> In the case the host only injects 1 IPv6 address, the dhcp flag is true, but
> we shouldn't ignore the IPv6 address and we should pass BOOTPROTO=none
> to the distro-specific script hv_set_ipconfig.
>
> Tested in Ubuntu 14.10 and RHEL7.
>
> Cc: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  tools/hv/hv_kvp_daemon.c | 47 +++++++++++++++++++++++++++++++----------------
>  1 file changed, 31 insertions(+), 16 deletions(-)
>
> diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> index 6a6432a..6ef6c04 100644
> --- a/tools/hv/hv_kvp_daemon.c
> +++ b/tools/hv/hv_kvp_daemon.c
> @@ -1145,6 +1145,9 @@ static int kvp_write_file(FILE *f, char *s1, char *s2, char *s3)
>  }
>
> +/* How many ipv6 addresses the host is trying to inject? */
> +static int num_ipv6_injected;
> +
>  static int process_ip_string(FILE *f, char *ip_string, int type)
>  {
>  	int error = 0;
> @@ -1190,6 +1193,7 @@ static int process_ip_string(FILE *f, char *ip_string, int type)
>  			switch (type) {
>  			case IPADDR:
>  				snprintf(str, sizeof(str), "%s", "IPV6ADDR");
> +				num_ipv6_injected++;
>  				break;
>  			case NETMASK:
>  				snprintf(str, sizeof(str), "%s", "IPV6NETMASK");
> @@ -1308,27 +1312,12 @@ static int kvp_set_ip_info(char *if_name, struct hv_kvp_ipaddr_value *new_val)
>  	if (error)
>  		goto setval_error;
>
> -	if (new_val->dhcp_enabled) {
> -		error = kvp_write_file(file, "BOOTPROTO", "", "dhcp");
> -		if (error)
> -			goto setval_error;
> -
> -		/*
> -		 * We are done!.
> -		 */
> -		goto setval_done;
> -
> -	} else {
> -		error = kvp_write_file(file, "BOOTPROTO", "", "none");
> -		if (error)
> -			goto setval_error;
> -	}
> -
>  	/*
>  	 * Write the configuration for ipaddress, netmask, gateway and
>  	 * name servers.
>  	 */
>
> +	num_ipv6_injected = 0;
>  	error = process_ip_string(file, (char *)new_val->ip_addr, IPADDR);
>  	if (error)
>  		goto setval_error;
> @@ -1345,6 +1334,32 @@ static int kvp_set_ip_info(char *if_name, struct hv_kvp_ipaddr_value *new_val)
>  	if (error)
>  		goto setval_error;
>
> +	/*
> +	 * Here "dhcp_enabled" is only for IPv4 according to Hyper-V host team.
> +	 *
> +	 * In the case the host only injects 1 IPv6 address:
> +	 * new_val->dhcp_enabled is true, but we can't pass BOOTPROTO=dhcp to
> +	 * the script hv_set_ifconfig, because in some distros (like RHEL7)
> +	 * BOOTPROTO=dhcp has a special meaning in the config file (e.g.,
> +	 * /etc/sysconfig/network-scripts/ifcfg-eth0): the network init program
> +	 * ignores any static IP addr information once there is
> +	 * BOOTPROTO=dhcp; as a result, IPv6-only injection can't work.
> +	 *
> +	 * In the case of IPv6-only injection, BOOTPROTO=dhcp doesn't affect
> +	 * Ubuntu because it's ignored by the Ubuntu version of
> +	 * hv_set_ifconfig and it doesn't seem to have special meaning in
> +	 * Ubuntu.
> +	 */

I just checked and adding "IPV6ADDR=something" when "BOOTPROTO=dhcp"
works for me with both RHEL7 and Fedora21.

Other than that I think bringing distribution specifics into kernel.git
is not a good idea. /etc/sysconfig/network-scripts/ifcfg-* format is
distro-specific and not all Linux distros support it. Moreover,
different distros can treat setting differently. I think it was wrong to
stick to this format in kvp daemon from very beginning.

As a solution I would suggest doing the following: kvp daemon writes all
received request details in distro-agnostic format in some temporary
place and then calls distro-specific script to set things up. Actually,
we already have such script: tools/hv/hv_set_ifconfig.sh

As for this bug I propose the following: remove skipping all
IPADDR/MASK/... settings in case of "BOOTPROTO=dhcp" and let
distro-specific script deal with the rest.


> +	if (new_val->dhcp_enabled && num_ipv6_injected == 0) {
> +		error = kvp_write_file(file, "BOOTPROTO", "", "dhcp");
> +		if (error)
> +			goto setval_error;
> +	} else {
> +		error = kvp_write_file(file, "BOOTPROTO", "", "none");
> +		if (error)
> +			goto setval_error;
> +	}
> +
>  setval_done:
>  	fclose(file);

-- 
  Vitaly
