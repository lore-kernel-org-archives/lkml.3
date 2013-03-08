Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933393Ab3CHKbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 05:31:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764Ab3CHKbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 05:31:02 -0500
Date: Fri, 8 Mar 2013 11:31:28 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Zdenek Kabelac <zkabelac@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Subject: Re: iwl3945 prints warning
Message-ID: <20130308103127.GA1427@redhat.com>
References: <5106867F.80309@redhat.com>
 <20130129130850.GC2306@redhat.com>
 <5139123D.8040901@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5139123D.8040901@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 07, 2013 at 11:18:37PM +0100, Zdenek Kabelac wrote:
> I've now tested  3.9-rc1  and it seems to be getting even worse.
> (and 3.8 is not really good either)
> 
> iwl3945 0000:03:00.0: Error sending C_RXON: time out after 500ms.
> iwl3945 0000:03:00.0: Error setting new configuration (-110).
This looks like firmware crash.

> ------------[ cut here ]------------
> WARNING: at lib/dma-debug.c:883 check_unmap+0xfb/0x9a0()
[snip]
> Pid: 50, comm: kworker/u:3 Not tainted 3.9.0-rc1-00114-gd356175 #144
Does this version include commit bdb084b22d8aee66c87af5e9c36bd6cf7f3bccfd
"iwlegacy: more checks for dma mapping errors" ?

>  iwl3945 0000:03:00.0: Microcode SW error detected. Restarting 0x82000008.
>  iwl3945 0000:03:00.0: Loaded firmware version: 15.32.2.9
>  iwl3945 0000:03:00.0: Start IWL Error Log Dump:
>  iwl3945 0000:03:00.0: Status: 0x000202E4, count: 1
>  iwl3945 0000:03:00.0: Desc       Time       asrtPC  blink2 ilink1  nmiPC   Line
>  iwl3945 0000:03:00.0: SYSASSERT     (0x5) 0000201255 0x008B6
> 0x00274 0x00320 0x04CA6 116
> 
>  iwl3945 0000:03:00.0: Error Reply type 0x00000005 cmd C_TX (0x1C)
> seq 0x0000 ser 0x00740000
>  iwl3945 0000:03:00.0: Error: Response NULL in 'C_ADD_STA'
>  iwl3945 0000:03:00.0: Adding station ff:ff:ff:ff:ff:ff failed.
>  iwl3945 0000:03:00.0: Error setting Tx power (-5).
>  iwl3945 0000:03:00.0: Can't stop Rx DMA.
>  ieee80211 phy0: Hardware restart was requested
> 
> 
> And driver is effectively unusable - since it's just restarting....
>
> Also 'state' of iwl3945 in  3.8 is quite 'far' from stable as well.
> quite often I can see, that I'm disconnected from AP, and while
> network manager shows other 'visible' AP available for connection,
> my home AP is not listed anymore - and to see it again I'd to switch
> wifi support on/off - just after this I'd reattach to my home AP -
> so quite annoying - and major reason to stay with 3.7 kernel for
> stable wifi.

We do not have much changes in iwlegacy driver between 3.7 and 3.8 (and
between 3.8 and 3.9). Most likely mac80211 changes are causing iwl3945
driver or firmware problems. Let's try to debug that on 3.8.

Please provide verbose debug messages, to do this you have to configure
syslog daemon to log kernel debug messages into some file, let say
/var/log/kernel. For rsyslogd this mean adding:

kern.*    /var/log/kernel

to /etc/rsyslog.conf

Then restart rsyslog service and grab debug messages:

modprobe -r iwl3945
echo > /var/log/kernel
modprobe iwl3945 debug=0x47ffffff

# Reproduce the problem

modprobe -r iwl3945

Then send me privately /var/log/kernel file (compressed if needed). 

Stanislaw
 
