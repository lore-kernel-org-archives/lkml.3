Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbaCZM1a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 08:27:30 -0400
Received: from 98-159-192-160.scottsboro.org ([98.159.192.160]:60991 "EHLO
	smtp.sboro.apirx.biz" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754140AbaCZM13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 08:27:29 -0400
X-Greylist: delayed 389 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Mar 2014 08:27:29 EDT
Message-ID: <5332C664.4060503@apinetstore.apirx.biz>
Date: Wed, 26 Mar 2014 08:21:56 -0400
From: Bill Shirley <bshirley@apinetstore.apirx.biz>
User-Agent: Mozilla/5.0 (Windows NT 5.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: ipsec using xfrm mark on kernel 3.13.5-101.fc19.x86_64 is broken
Content-Type: multipart/mixed;
 boundary="------------060402010203080008070907"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060402010203080008070907
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I apologize in advance if I'm posting this to the wrong list.  Also, I've attempted to post in plain text; I hope 
Thunderbird behaves.


I have set up a ipsec tunnel between Server-A and Server-B using public IP addresses and configured the ip xfrm state 
and ip xfrm policy database to use marks.  This works correctly if both servers are not using a newer kernel.  I have 
this working with (1st setup) :
Server-A kernel 3.6.9-2.fc17.x86_64 <-> Server-B kernel 3.6.3-1.fc17.x86_64 (no marks this side)
also:
Server-A kernel 3.6.9-2.fc17.x86_64 <-> Server-B kernel 3.4.2-1.fc16.x86_64

However, this doesn't work completely with this setup (2nd setup) :
Server-A kernel 3.4.2-1.fc16.x86_64 <-> Server-B kernel 3.13.5-101.fc19.x86_64
nor with:
Server-A kernel 2.6.33.7-server-2mnb (Mandriva 2010, no marks this side) <-> Server-B kernel 3.12.11-201.fc19.x86_64

Keep in mind that this is a TUNNEL ipsec using MARKS (mark 12032/0xff00).  On the 2nd setup, all traffic flows for:
PC-A <-> Server-A <-> Server-B <-> PC-B
PC-A <-> Server-A <-> Server-B
                   Server-A <-> Server-B <-> PC-B

Actual values for Server-A kernel 3.4.2-1.fc16.x86_64 (192.168.64.0/23 (yes, /23) <-> Server-B kernel 
3.13.5-101.fc19.x86_64  (10.0.0.0/8):
192.168.65.137 = PC-A
192.168.64.1 = Server-A
10.96.0.9 = Server-B
10.96.0.8 = PC-B

However, SSH doesn't work for (either direction):
Server-A <-> Server-B

These do work:
ping
dig axfr
telnet imap
links http://

I get incomplete response (takes a long time):
from Server-A: smbclient -L 10.96.0.9

However this works completely and swiftly:
from Server-B: smbclient -L 192.168.64.1

Something about ipsec in the OUTPUT chain on newer kernels is broken.  In the Server-B mangle table I can put a dummy 
mark (outside the xfrm mask, of course) on outgoing SSH traffic and ESP traffic and observe that the ssh daemon on the 
3.13.5 kernel DOES respond to all packets but not all packets are encrypted and sent out the wire.

I've attached a portion of my iptables OUTPUT chain to demonstrate this.  This is from:
Server-A kernel 2.6.33.7-server-2mnb (Mandriva 2010, no marks this side) <-> Server-B kernel 3.12.11-201.fc19.x86_64
192.168.0.231/24 <-> 172.20.8.3/24
mangle.ssh.txt => ssh 192.168.0.231
mangle.imap.txt => telnet 192.168.0.231 imap

I chose this pair because Server-B is idle and there is no other esp traffic.

What is different about the way openssh and smbclient operate that fails vs several other programs not failing?  There 
may be other programs failing, I just haven't though of any to test.

Any help or pointers is much appreciated.

Thanks,
Bill


--------------060402010203080008070907
Content-Type: text/plain; charset=windows-1252;
 name="mangle.ssh.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mangle.ssh.txt"

# telnet 192.168.0.231 143
Chain OUTPUT (policy ACCEPT 25911 packets, 2907K bytes)
 pkts bytes target     prot opt in     out     source               destination         
25911 2907K tcout      all  --  *      *       0.0.0.0/0            0.0.0.0/0           

Chain tcout (1 references)
 pkts bytes target     prot opt in     out     source               destination         
   49 67341 MARK       tcp  --  *      *       172.20.8.3           192.168.0.231        tcp dpt:22 /* mark ssh packet */ MARK xset 0x2f00/0xff00
   49 67341 CONNMARK   tcp  --  *      *       172.20.8.3           192.168.0.231        tcp dpt:22 /* mark ssh connection */ CONNMARK xset 0x2f00/0xff00
   49 67341 MARK       tcp  --  *      *       172.20.8.3           192.168.0.231        tcp dpt:22 mark match 0x2f00/0xff00 /* count ssh packet with mark */ MARK or 0x400000
   49 67341 MARK       tcp  --  *      *       172.20.8.3           192.168.0.231        tcp dpt:22 connmark match  0x2f00/0xff00 /* count ssh packet with conn mark */ MARK or 0x400000
    4   448 MARK       esp  --  *      *       0.0.0.0/0            0.0.0.0/0            /* count any esp outflow */ MARK or 0x400000
    4   448 MARK       esp  --  *      *       0.0.0.0/0            pub.lic.ip.A         /* count esp outflow to partner */ MARK or 0x400000

--------------060402010203080008070907
Content-Type: text/plain; charset=windows-1252;
 name="ip.xfrm.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ip.xfrm.txt"

# ip xfrm state list
src pub.lic.ip.A dst pub.lic.ip.B
	proto esp spi 0x00000400 reqid 0 mode tunnel
	replay-window 0 
	mark 12032/0xff00
	auth-trunc hmac(sha1) 0x2ea6eefd6c7e1f41dfd047ad83d2d11f46428a4f 96
	enc cbc(des3_ede) 0x394517be5524859ce745e158e3c7d47c033fe519bb882496
	sel src 0.0.0.0/0 dst 0.0.0.0/0 
src pub.lic.ip.B dst pub.lic.ip.A
	proto esp spi 0x00000401 reqid 0 mode tunnel
	replay-window 0 
	mark 12032/0xff00
	auth-trunc hmac(sha1) 0xbf11eda9dcce27e8ca2156d2a0fb3ce3d31251bf 96
	enc cbc(des3_ede) 0x346c928bae81ed623dca2b8d2b16365c91daf629076692e0
	sel src 0.0.0.0/0 dst 0.0.0.0/0 

# ip xfrm policy list
src 192.168.0.0/24 dst 172.20.8.0/24 
	dir fwd priority 0 ptype main 
	mark 12032/0xff00
	tmpl src pub.lic.ip.A dst pub.lic.ip.B
		proto esp reqid 0 mode tunnel
src 192.168.0.0/24 dst 172.20.8.0/24 
	dir in priority 0 ptype main 
	mark 12032/0xff00
	tmpl src pub.lic.ip.A dst pub.lic.ip.B
		proto esp reqid 0 mode tunnel
src 172.20.8.0/24 dst 192.168.0.0/24 
	dir out priority 0 ptype main 
	mark 12032/0xff00
	tmpl src pub.lic.ip.B dst pub.lic.ip.A
		proto esp reqid 0 mode tunnel

--------------060402010203080008070907
Content-Type: text/plain; charset=windows-1252;
 name="mangle.imap.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mangle.imap.txt"

# ssh 192.168.0.231
Chain OUTPUT (policy ACCEPT 25911 packets, 2907K bytes)
 pkts bytes target     prot opt in     out     source               destination         
25911 2907K tcout      all  --  *      *       0.0.0.0/0            0.0.0.0/0           

Chain tcout (1 references)
 pkts bytes target     prot opt in     out     source               destination         
   17   944 MARK       tcp  --  *      *       172.20.8.3           192.168.0.231        tcp dpt:143 /* mark imap packet */ MARK xset 0x2f00/0xff00
   17   944 CONNMARK   tcp  --  *      *       172.20.8.3           192.168.0.231        tcp dpt:143 /* mark imap connection */ CONNMARK xset 0x2f00/0xff00
   17   944 MARK       tcp  --  *      *       172.20.8.3           192.168.0.231        tcp dpt:143 mark match 0x2f00/0xff00 /* count imap packet with mark */ MARK or 0x400000
   17   944 MARK       tcp  --  *      *       172.20.8.3           192.168.0.231        tcp dpt:143 connmark match  0x2f00/0xff00 /* count imap packet with conn mark */ MARK or 0x400000
   17  1848 MARK       esp  --  *      *       0.0.0.0/0            0.0.0.0/0            /* count any esp outflow */ MARK or 0x400000
   17  1848 MARK       esp  --  *      *       0.0.0.0/0            pub.lic.ip.A         /* count esp outflow to partner */ MARK or 0x400000

--------------060402010203080008070907--
