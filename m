Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbaLROX2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 09:23:28 -0500
Received: from mout.gmx.net ([212.227.17.21]:50191 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbaLROX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 09:23:27 -0500
Message-ID: <5492E35B.2010704@gmx.de>
Date: Thu, 18 Dec 2014 15:23:23 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>, syslog-ng@lists.balabit.hu
Subject: iptables LOG syslog timestamps delayed by about 6 minutes
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:e6rMyoebb6JSDHKt7E+m9vM0PUgJp1ArYL/uP8jsHwprtUudyyT
 I1WsTrYXfb9dKclkIIBibRt83IJYAyC975NQ1zv/StrYnNNWVTERRds/R0+x/1wCID/qtwJ
 K6bPijCd3Rg+m0HHgz94rNkBsWtiiR2MySKAnBQG6gTZ0jBtEk8A2txVVHIeRg/GaMx7+2z
 yeBjf8zcz5cGLyF4iMwHA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[@balabit ML: pls Cc: me I'm not subscribed]

It looks a little bit odd to me, that this rule :

$IPT -t filter -A INPUT --match limit --limit 1/second --limit-burst 10 -j LOG --log-prefix "MYFW4 "

logs timestamps which are delayed about 6 minutes wrt to other log messages (for comparisation I made a $>logger "huhu") :

# grep -B 1 -A 1 huhu /var/log/messages
Dec 18 15:04:09 tor-relay kernel: PORTSCAN 80 <scrubbed>
Dec 18 15:10:01 tor-relay tfoerste[15080]: huhu
Dec 18 15:04:09 tor-relay kernel: PORTSCAN 80 <scrubbed>

Yesterday the delay was about 5 minutes - so the delay increases over time. I restarted/reloaded both syslogd and the firewall script few times + activated/deactivated the logging rule. FWIW I do have these rules for syslog defined :


--------------------------------------------------------------------------------
destination d_myfw     { file("/var/log/myfw/ipv4.log"); };
destination d_portscan { file("/mnt/ramdisk/portscan"); };


rewrite r_scrubb_ip {
        subst('\b(1?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\.(1?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\.(1?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\.(1?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\b',
        "scrubbed", value("MESSAGE"), type("pcre"), flags("global"));
};
rewrite r_truncate {
        subst(' IN=.*', "", value("MESSAGE"), type("pcre"), flags("global"));
};


filter f_myfw     {     match("MYFW4 "           value("MSG")); };
filter f_messages { not match("MYFW4 |PORTSCAN " value("MSG")); };
filter f_portscan {     match("PORTSCAN "        value("MSG")); };


log { source(src); filter(f_myfw); destination(d_myfw); };
log { source(src); filter(f_portscan); rewrite(r_scrubb_ip); destination(d_portscan); };
log { source(src); filter(f_portscan); rewrite(r_truncate); destination(d_portscan); };

#log { source(src); filter(f_messages); destination(messages); };
log { source(src); destination(messages); };
log { source(src); filter(f_messages); destination(console_all); };
--------------------------------------------------------------------------------

The system is a 64 bit hardened Gentoo Linux w/ kernel 3.17.6 and syslog-ng 3.6.1

-- 
Toralf
pgp key: 7B1A 07F4 EC82 0F90 D4C2  8936 872A E508 0076 E94E

