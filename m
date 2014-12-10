Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbaLJKtm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 05:49:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755758AbaLJKtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 05:49:40 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Dexuan Cui <decui@microsoft.com>
Cc: "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel\@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        "olaf\@aepfle.de" <olaf@aepfle.de>,
        "apw\@canonical.com" <apw@canonical.com>,
        "jasowang\@redhat.com" <jasowang@redhat.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH] tools: hv: kvp_daemon: make IPv6-only-injection work
References: <1418126489-20627-1-git-send-email-decui@microsoft.com>
	<877fy1ht1u.fsf@vitty.brq.redhat.com>
	<F792CF86EFE20D4AB8064279AFBA51C613E9B7F7@SIXPRD3002MB028.064d.mgd.msft.net>
Date: Wed, 10 Dec 2014 10:06:40 +0100
In-Reply-To: <F792CF86EFE20D4AB8064279AFBA51C613E9B7F7@SIXPRD3002MB028.064d.mgd.msft.net>
	(Dexuan Cui's message of "Wed, 10 Dec 2014 07:34:19 +0000")
Message-ID: <87tx13ho0v.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dexuan Cui <decui@microsoft.com> writes:

>> -----Original Message-----
>> From: Vitaly Kuznetsov [mailto:vkuznets@redhat.com]
>> Sent: Tuesday, December 9, 2014 21:06 PM
>> To: Dexuan Cui
>> Cc: gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org; driverdev-
>> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
>> jasowang@redhat.com; KY Srinivasan; Haiyang Zhang
>> Subject: Re: [PATCH] tools: hv: kvp_daemon: make IPv6-only-injection work
>>  ......
>> > +	 * Here "dhcp_enabled" is only for IPv4 according to Hyper-V host
>> team.
>> > +	 *
>> > +	 * In the case the host only injects 1 IPv6 address:
>> > +	 * new_val->dhcp_enabled is true, but we can't pass
>> BOOTPROTO=dhcp to
>> > +	 * the script hv_set_ifconfig, because in some distros (like RHEL7)
>> > +	 * BOOTPROTO=dhcp has a special meaning in the config file (e.g.,
>> > +	 * /etc/sysconfig/network-scripts/ifcfg-eth0): the network init
>> program
>> > +	 * ignores any static IP addr information once there is
>> > +	 * BOOTPROTO=dhcp; as a result, IPv6-only injection can't work.
>> > +	 *
>> > +	 * In the case of IPv6-only injection, BOOTPROTO=dhcp doesn't affect
>> > +	 * Ubuntu because it's ignored by the Ubuntu version of
>> > +	 * hv_set_ifconfig and it doesn't seem to have special meaning in
>> > +	 * Ubuntu.
>> > +	 */
>> 
>> I just checked and adding "IPV6ADDR=something" when "BOOTPROTO=dhcp"
>> works for me with both RHEL7 and Fedora21.
> It doesn't work in my side. :-(
> Running 'ifup eth0' shows some errors(I use "set -x")
> ...
> + /sbin/dhclient -H localhost -1 -q -lf /var/lib/dhclient/dhclient--eth0.lease -pf /var/run/dhclient-eth0.pid eth0
> grep: /etc/sysconfig/network-scripts/ifcfg-eth0: Permission dinied.
> grep: /etc/sysconfig/network-scripts/ifcfg-eth0: Permission dinied.
> grep: /etc/sysconfig/network-scripts/ifcfg-eth0: Permission dinied.
> grep: /etc/sysconfig/network-scripts/ifcfg-eth0: Permission dinied.
> grep: /etc/sysconfig/network-scripts/ifcfg-eth0: Permission dinied.
> grep: /etc/sysconfig/network-scripts/ifcfg-eth0: Permission dinied.
> done.
>
> I'm trying to find out the cause.

Selinux? You can try 'setenforce 0' to figure this out.

>
>> Other than that I think bringing distribution specifics into kernel.git
>> is not a good idea. /etc/sysconfig/network-scripts/ifcfg-* format is
>> distro-specific and not all Linux distros support it. Moreover,
> I agree.
>
>> different distros can treat setting differently. I think it was wrong to
>> stick to this format in kvp daemon from very beginning.
> We can also think the current format used in kvp daemon is already
> distro-agnostic -- it just happens to look like the style of network config file
> used in RHEL :-)

Yes, it is already there and I don't see any point in changing it.

>
>> 
>> As a solution I would suggest doing the following: kvp daemon writes all
>> received request details in distro-agnostic format in some temporary
>> place and then calls distro-specific script to set things up. Actually,
>> we already have such script: tools/hv/hv_set_ifconfig.sh
> Yeah, this is exactly what we already have today.
>
>> As for this bug I propose the following: remove skipping all
>> IPADDR/MASK/... settings in case of "BOOTPROTO=dhcp" and let
>> distro-specific script deal with the rest.
>> --
>>   Vitaly
> OK, so the patch would be 1-line only:
>
> diff --git a/tools/hv/hv_kvp_daemon.c b/tools/hv/hv_kvp_daemon.c
> index 22b0764..53fdaad 100644
> --- a/tools/hv/hv_kvp_daemon.c
> +++ b/tools/hv/hv_kvp_daemon.c
> @@ -1314,10 +1314,8 @@ static int kvp_set_ip_info(char *if_name, struct hv_kvp_ipaddr_value *new_val)
>                         goto setval_error;
>
>                 /*
> -                * We are done!.
> +                * We are not done... TODO: add comment here.
>                  */
> -               goto setval_done;
> -
>         } else {
>                 error = kvp_write_file(file, "BOOTPROTO", "", "none");
>                 if (error)
>
> I'll send out a v2 after I resolve the "grep ... Permission dinied" issue.
>
> Thanks,
> -- Dexuan

-- 
  Vitaly
