Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbaLGWFM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 17:05:12 -0500
Received: from mail.smart-weblications.de ([188.65.144.61]:56061 "EHLO
	mail.smart-weblications.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753246AbaLGWFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 17:05:09 -0500
Message-ID: <5484CEE7.4030307@smart-weblications.de>
Date: Sun, 07 Dec 2014 23:04:23 +0100
From: Smart Weblications GmbH - Florian Wiessner 
	<f.wiessner@smart-weblications.de>
Reply-To: f.wiessner@smart-weblications.de
Organization: Smart Weblications GmbH
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Julian Anastasov <ja@ssi.bg>
CC: Steffen Klassert <steffen.klassert@secunet.com>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org
Subject: Re: 3.12.33 - BUG xfrm_selector_match+0x25/0x2f6
References: <547F2462.6040405@smart-weblications.de> <20141204075627.GE6390@secunet.com> <alpine.LFD.2.11.1412042338370.4841@ja.home.ssi.bg> <5481173A.9060308@smart-weblications.de> <alpine.LFD.2.11.1412051126090.2522@ja.home.ssi.bg> <5481B944.2000002@smart-weblications.de> <alpine.LFD.2.11.1412052249570.1825@ja.home.ssi.bg>
In-Reply-To: <alpine.LFD.2.11.1412052249570.1825@ja.home.ssi.bg>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am 05.12.2014 22:32, schrieb Julian Anastasov:
> 
> 	Hello,
> 
> On Fri, 5 Dec 2014, Smart Weblications GmbH - Florian Wiessner wrote:
> 
>> thank you for the fast responses! I would like to test any patch for 3.12.
> 
> 	I hope I'll have time this weekend...
> 
>> If i understand correctly, i set:
>>
>> echo 0 > /proc/sys/net/ipv4/vs/snat_reroute
> 
> 	The flag works per-packet, no need to reload any modules.
> But it does not help for the case with local client where
> the problem with sockets occurs, that is why you can keep 
> ip_vs_route_me_harder() empty (return 0) until patch is
> created.
> 
>> modprobe ip_vs_ftp
>>
>> and reenable ftp ipvs?
>>
>> It does not crash, but ftp is not working with neither PASV nor PORT:
>>
>>
>> [14:47:42] [R] Verbindung herstellen zu 192.168.10.62 -> IP=192.168.10.62 PORT=21
>> [14:47:42] [R] Verbunden mit 192.168.10.62
>> [14:47:43] [R] 220 (vsFTPd 3.0.2)
>> [14:47:43] [R] USER (hidden)
>> [14:47:43] [R] 331 Please specify the password.
>> [14:47:43] [R] PASS (hidden)
>> [14:47:43] [R] 230 Login successful.
>> [14:47:43] [R] SYST
>> [14:47:43] [R] 215 UNIX Type: L8
>> [14:47:43] [R] FEAT
>> [14:47:43] [R] 211-Features:
>> [14:47:43] [R]  EPRT
>> [14:47:43] [R]  EPSV
>> [14:47:43] [R]  MDTM
>> [14:47:43] [R]  PASV
>> [14:47:43] [R]  REST STREAM
>> [14:47:43] [R]  SIZE
>> [14:47:43] [R]  TVFS
>> [14:47:43] [R]  UTF8
>> [14:47:43] [R] 211 End
>> [14:47:43] [R] PWD
>> [14:47:43] [R] 257 "/"
>> [14:47:43] [R] CWD /
>> [14:47:43] [R] 250 Directory successfully changed.
>> [14:47:43] [R] PWD
>> [14:47:43] [R] 257 "/"
>> [14:47:43] [R] TYPE A
>> [14:47:43] [R] 200 Switching to ASCII mode.
>> [14:47:43] [R] PASV
>> [14:47:43] [R] 227 Entering Passive Mode (10,10,1,23,251,6).
>> [14:47:43] [R] Datenkanal-IP öffnen: 192.168.10.62 PORT: 64262
>> [14:47:44] [R] Datensocket-Fehler: Verbindung abgewiesen
>> [14:47:44] [R] List Fehler
>> [14:47:44] [R] PASV
>> [14:47:44] [R] 227 Entering Passive Mode (10,10,1,23,250,144).
>> [14:47:44] [R] Datenkanal-IP öffnen: 192.168.10.62 PORT: 64144
>> [14:47:45] [R] Datensocket-Fehler: Verbindung abgewiesen
>> [14:47:45] [R] List Fehler
>> [14:47:45] [R] PASV-Modus fehlgeschlagen, PORT -Modus versuchen...
>> [14:47:45] [R] Auf PORT: 62505 warten, Verbindung erwarten.
>> [14:47:45] [R] PORT 192,168,200,13,244,41
>> [14:47:45] [R] 500 Illegal PORT command.
> 
> 	Who is 192.168.200.13? From vsftpd-3.0.2/postlogin.c,
> handle_port():
> 

192.168.200.13 was the ftp client. As this client also was natted, PORT Mode
will fail here because the client provided the internal ip, but i disabled PORT
anyways before and did reenable it only to test...


>   /* SECURITY:
>    * 1) Reject requests not connecting to the control socket IP
>    * 2) Reject connects to privileged ports
>    */
> 
> 	It looks like PORT command provides different IP.
> IIRC, IPVS does not mangle PORT command, vsftpd expects to
> connect to the same client IP. There is config option you can
> try to set (port_promiscuous), only while testing.
> 

While this is true, PASV should have worked anyhow, right?


-- 

Mit freundlichen Grüßen,

Florian Wiessner

Smart Weblications GmbH
Martinsberger Str. 1
D-95119 Naila

fon.: +49 9282 9638 200
fax.: +49 9282 9638 205
24/7: +49 900 144 000 00 - 0,99 EUR/Min*
http://www.smart-weblications.de

--
Sitz der Gesellschaft: Naila
Geschäftsführer: Florian Wiessner
HRB-Nr.: HRB 3840 Amtsgericht Hof
*aus dem dt. Festnetz, ggf. abweichende Preise aus dem Mobilfunknetz
