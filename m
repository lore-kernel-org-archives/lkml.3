Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbaHaXZE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 19:25:04 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:55883 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbaHaXZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 19:25:03 -0400
X-Greylist: delayed 1045 seconds by postgrey-1.27 at vger.kernel.org; Sun, 31 Aug 2014 19:25:02 EDT
From: Nix <nix@esperi.org.uk>
To: oliver@neukum.org
Cc: linux-kernel@vger.kernel.org
Subject: [3.16.1 REGRESSION]: Simtec Entropy Key (cdc-acm) broken in 3.16
Emacs: resistance is futile; you will be assimilated and byte-compiled.
Date: Mon, 01 Sep 2014 00:07:34 +0100
Message-ID: <878um4tg09.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-wuwien-Metrics: spindle 1290; Body=2 Fuz1=2 Fuz2=2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I upgraded to 3.16.1 and found that the Simtec Entropy Key (a cdc-acm
device) was no longer operational:

fold:~# ekeydctl stats 1
BytesRead=0
BytesWritten=0
ConnectionNonces=0
ConnectionPackets=0
ConnectionRekeys=0
ConnectionResets=0
ConnectionTime=65
EntropyRate=0
FipsFrameRate=0
FrameByteLast=0
FramesOk=0
FramingErrors=0
KeyDbsdShannonPerByteL=0
KeyDbsdShannonPerByteR=0
KeyEnglishBadness=No failure
KeyRawBadness=0
KeyRawShannonPerByteL=0
KeyRawShannonPerByteR=0
KeyRawShannonPerByteX=0
KeyShortBadness=efm_ok
KeyTemperatureC=-273.15
KeyTemperatureF=-459.67
KeyTemperatureK=0
KeyVoltage=0
PacketErrors=0
PacketOK=0
ReadRate=0
TotalEntropy=0
WriteRate=0

This device streams data continuously at at rate of several KiB/s, so
normally we would never expect to see a report of zero bytes read or
written if the key were functional (nor, indeed, a key temperature of
absolute zero!)

It appears that cdc-acm has broken such that no data is received from
this device any more (though it's still being detected, according to the
dmesg log). Something goes very askew with the entropy key -- even after
rebooting back to an earlier kernel, a physical disconnection and
reconnection of the entropy key is needed to make it work again. Whether
this is some sort of cdc-acm-level protocol problem, or a key-level
problem caused by interrupted communication, I have no clue.

3.15.8 works fine.

I'll do a bisection of the cdc-acm changes since 3.15 tomorrow night and
see if I can find the commit at fault.

-- 
NULL && (void)
