Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423427Ab3CVVcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 17:32:09 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:39664 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423310Ab3CVVbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 17:31:50 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Benoit Lourdelet <blourdel@juniper.net>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lxc-users <lxc-users@lists.sourceforge.net>
References: <CD724CB7.72DE%blourdel@juniper.net>
Date: Fri, 22 Mar 2013 14:31:32 -0700
In-Reply-To: <CD724CB7.72DE%blourdel@juniper.net> (Benoit Lourdelet's message
	of "Fri, 22 Mar 2013 17:05:44 +0000")
Message-ID: <87r4j7m897.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/qGq5VAkm33NJlSn71FlyZVefHYhJ2UTA=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.0 XMSubMetaSx_00 1+ Sexy Words
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Benoit Lourdelet <blourdel@juniper.net>
X-Spam-Relay-Country: 
Subject: Re: [Lxc-users] Containers slow to start after 1600
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benoit Lourdelet <blourdel@juniper.net> writes:

> Hello,
>
> I tried multiple kernels with similar results.
>
> I ran the following on 3.8.2
>
> $ cat > test-script.sh << 'EOF'
> #!/bin/bash
> for i in $(seq 1 2000) ; do
> 	ip link add a$i type veth peer name b$i
> done
> EOF
>
> $ perf record -a test-script.sh
> $ perf report
>

Interesting.  And the snmp_fold_field is an interesting hint.

It looks like something is listing all of your interfaces probably
between interface creation.  And that will definitely take this
process from O(NlogN) to O(N^2).

Although I find the find_next_bit call also concerning.

snmp_fold_field is used when reading /proc/net/snmp /proc/net/netstat
and when running ip link to show all of the interfaces.

I suspect find_next_bit is coming out of the per cpu allocator, and it
might be partially responsible.  But that doesn't feel right.

Regardless from this trace it looks like the performance problem on
creation is something in userspace is calling /sbin/ip to list all of
the interfaces and that is  causing the interface creation to slow down.


Oh I see what is happening.  In iproute.
do_iplink
  iplink_modify
     ll_init_map

So the limitation at this point is in iproute, and not in the kernel.

And with the following patch the time to create 5000 devices drops from
120 to 11 seconds for me.  So it looks like the kernel is fine it is
whatever userspace tools that are of interest that are the bottleneck.

Although a quicker way to do a name to ifindex mapping might be
interesting.

Eric


diff --git a/ip/iplink.c b/ip/iplink.c
index ad33611..58af369 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -533,8 +533,6 @@ static int iplink_modify(int cmd, unsigned int flags, int argc, char **argv)
                }
        }
 
-       ll_init_map(&rth);
-
        if (!(flags & NLM_F_CREATE)) {
                if (!dev) {
                        fprintf(stderr, "Not enough information: \"dev\" "
@@ -542,6 +540,7 @@ static int iplink_modify(int cmd, unsigned int flags, int argc, char **argv)
                        exit(-1);
                }
 
+               ll_init_map(&rth);
                req.i.ifi_index = ll_name_to_index(dev);
                if (req.i.ifi_index == 0) {
                        fprintf(stderr, "Cannot find device \"%s\"\n", dev);
@@ -555,6 +554,7 @@ static int iplink_modify(int cmd, unsigned int flags, int argc, char **argv)
                if (link) {
                        int ifindex;
 
+                       ll_init_map(&rth);
                        ifindex = ll_name_to_index(link);
                        if (ifindex == 0) {
                                fprintf(stderr, "Cannot find device \"%s\"\n",




