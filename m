Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaLEVkc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 16:40:32 -0500
Received: from ja.ssi.bg ([178.16.129.10]:47330 "EHLO ja.ssi.bg"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752060AbaLEVk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 16:40:29 -0500
Date: Fri, 5 Dec 2014 23:32:14 +0200 (EET)
From: Julian Anastasov <ja@ssi.bg>
To: Smart Weblications GmbH - Florian Wiessner 
	<f.wiessner@smart-weblications.de>
cc: Steffen Klassert <steffen.klassert@secunet.com>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org
Subject: Re: 3.12.33 - BUG xfrm_selector_match+0x25/0x2f6
In-Reply-To: <5481B944.2000002@smart-weblications.de>
Message-ID: <alpine.LFD.2.11.1412052249570.1825@ja.home.ssi.bg>
References: <547F2462.6040405@smart-weblications.de> <20141204075627.GE6390@secunet.com> <alpine.LFD.2.11.1412042338370.4841@ja.home.ssi.bg> <5481173A.9060308@smart-weblications.de> <alpine.LFD.2.11.1412051126090.2522@ja.home.ssi.bg>
 <5481B944.2000002@smart-weblications.de>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811672-511558398-1417815134=:1825"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811672-511558398-1417815134=:1825
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT


	Hello,

On Fri, 5 Dec 2014, Smart Weblications GmbH - Florian Wiessner wrote:

> thank you for the fast responses! I would like to test any patch for 3.12.

	I hope I'll have time this weekend...

> If i understand correctly, i set:
> 
> echo 0 > /proc/sys/net/ipv4/vs/snat_reroute

	The flag works per-packet, no need to reload any modules.
But it does not help for the case with local client where
the problem with sockets occurs, that is why you can keep 
ip_vs_route_me_harder() empty (return 0) until patch is
created.

> modprobe ip_vs_ftp
> 
> and reenable ftp ipvs?
> 
> It does not crash, but ftp is not working with neither PASV nor PORT:
> 
> 
> [14:47:42] [R] Verbindung herstellen zu 192.168.10.62 -> IP=192.168.10.62 PORT=21
> [14:47:42] [R] Verbunden mit 192.168.10.62
> [14:47:43] [R] 220 (vsFTPd 3.0.2)
> [14:47:43] [R] USER (hidden)
> [14:47:43] [R] 331 Please specify the password.
> [14:47:43] [R] PASS (hidden)
> [14:47:43] [R] 230 Login successful.
> [14:47:43] [R] SYST
> [14:47:43] [R] 215 UNIX Type: L8
> [14:47:43] [R] FEAT
> [14:47:43] [R] 211-Features:
> [14:47:43] [R]  EPRT
> [14:47:43] [R]  EPSV
> [14:47:43] [R]  MDTM
> [14:47:43] [R]  PASV
> [14:47:43] [R]  REST STREAM
> [14:47:43] [R]  SIZE
> [14:47:43] [R]  TVFS
> [14:47:43] [R]  UTF8
> [14:47:43] [R] 211 End
> [14:47:43] [R] PWD
> [14:47:43] [R] 257 "/"
> [14:47:43] [R] CWD /
> [14:47:43] [R] 250 Directory successfully changed.
> [14:47:43] [R] PWD
> [14:47:43] [R] 257 "/"
> [14:47:43] [R] TYPE A
> [14:47:43] [R] 200 Switching to ASCII mode.
> [14:47:43] [R] PASV
> [14:47:43] [R] 227 Entering Passive Mode (10,10,1,23,251,6).
> [14:47:43] [R] Datenkanal-IP öffnen: 192.168.10.62 PORT: 64262
> [14:47:44] [R] Datensocket-Fehler: Verbindung abgewiesen
> [14:47:44] [R] List Fehler
> [14:47:44] [R] PASV
> [14:47:44] [R] 227 Entering Passive Mode (10,10,1,23,250,144).
> [14:47:44] [R] Datenkanal-IP öffnen: 192.168.10.62 PORT: 64144
> [14:47:45] [R] Datensocket-Fehler: Verbindung abgewiesen
> [14:47:45] [R] List Fehler
> [14:47:45] [R] PASV-Modus fehlgeschlagen, PORT -Modus versuchen...
> [14:47:45] [R] Auf PORT: 62505 warten, Verbindung erwarten.
> [14:47:45] [R] PORT 192,168,200,13,244,41
> [14:47:45] [R] 500 Illegal PORT command.

	Who is 192.168.200.13? From vsftpd-3.0.2/postlogin.c,
handle_port():

  /* SECURITY:
   * 1) Reject requests not connecting to the control socket IP
   * 2) Reject connects to privileged ports
   */

	It looks like PORT command provides different IP.
IIRC, IPVS does not mangle PORT command, vsftpd expects to
connect to the same client IP. There is config option you can
try to set (port_promiscuous), only while testing.

> [14:47:45] [R] List Fehler
> [14:48:14] [R] QUIT
> [14:48:14] [R] 221 Goodbye.
> [14:48:14] [R] Ausgeloggt: 192.168.10.62

Regards

--
Julian Anastasov <ja@ssi.bg>
---1463811672-511558398-1417815134=:1825--
