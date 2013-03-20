Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab3CTUiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 16:38:18 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:35593 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541Ab3CTUiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 16:38:16 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Benoit Lourdelet <blourdel@juniper.net>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        lxc-users <lxc-users@lists.sourceforge.net>
References: <CD6F35B6.7221%blourdel@juniper.net>
Date: Wed, 20 Mar 2013 13:38:08 -0700
In-Reply-To: <CD6F35B6.7221%blourdel@juniper.net> (Benoit Lourdelet's message
	of "Wed, 20 Mar 2013 20:09:29 +0000")
Message-ID: <87vc8ldcy7.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18zjjZxttxfuARfpX9ReewMssRYo9e8crU=
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
> The measurement has been done with kernel 3.8.2.
>
> Linux ieng-serv06 3.7.9 #3 SMP Wed Feb 27 02:38:58 PST 2013 x86_64 x86_64
> x86_64 GNU/Linux

Two different kernel versions?

> What information would you like to see on the kernel ?

The question is where is the kernel spending it's time.  So profiling
information should help us see that.  Something like.

$ cat > test-script.sh << 'EOF'
#!/bin/bash
for i in $(seq 1 2000) ; do
	ip link add a$i type veth peer name b$i
done
EOF

$ perf record -a -g test-script.sh
$ perf report 

I don't do anywhere enough work with perf to remember what good options
are.

You definititely don't want to time anything you are doing something
silly like asking ip link add to generate device names which is O(N^2)
when you create one device at a time.

And of course there is the interesting discrepency.  Why can I add 5000
veth pairs in 120 seconds and it takes you 1123 seconds.  Do you have a very
slow cpu in your test environment?  Or was your test asking the kernel
to generate names.

Once we know where the kernel is spending it's time we can look to see
if there is anything that is easy to fix, and where to point you.

Both my timing and yours indicates that there is something taking O(N^2)
time in there.  So it would at least be interesting to see what that
something is.

Eric
