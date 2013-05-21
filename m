Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab3EUOJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 10:09:52 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:45625 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab3EUOJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 10:09:50 -0400
Message-ID: <519B8021.6030002@gmail.com>
Date: Tue, 21 May 2013 16:09:37 +0200
From: Kshitij Kulshreshtha <kkhere.geo@gmail.com>
Reply-To: kkhere.geo+suse@gmail.com
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20121216 Icedove/3.0.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
CC: gregkh@kroah.com
Subject: [v3.9.x stable regression, bisected] iwlwifi/iwldvm has a 30s delay
 in EAP authentication
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am currently running the openSUSE Tumbleweed distribution and have a
problem starting with the kernel v3.9.1 and also with kernel v3.9.2.

The iwldvm driver has an artificial delay of 30s when authenticating
with a radius server using EAP-TLS. This was not the case using kernel
v3.9.

I bisected the problem using local builds of the tumbleweed desktop
configuration. This is the result:

c30f37f8f1f8d06c142d67ba74955fd48b5cf5a4 is the first bad commit
commit c30f37f8f1f8d06c142d67ba74955fd48b5cf5a4
Author: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date:   Wed Apr 17 09:47:00 2013 +0300

    iwlwifi: dvm: don't send zeroed LQ cmd

    commit 63b77bf489881747c5118476918cc8c29378ee63 upstream.

    When the stations are being restored because of unassoc
    RXON, the LQ cmd may not have been initialized because it
    is initialized only after association.
    Sending zeroed LQ_CMD makes the fw unhappy: it raises
    SYSASSERT_2078.

    Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    Reviewed-by: Johannes Berg <johannes.berg@intel.com>
    [move zero_lq and make static const]
    Signed-off-by: Johannes Berg <johannes.berg@intel.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

:040000 040000 fb6795b349a1765f357df8fcdf309e6e2613230b
5e542c8aef84287968515803efd193462c4a0d6b M      drivers

Reverting the above commit on top of kernel v3.9.3 fixes this 30s delay
but I've never seen a firmware restart of the iwldvm/iwlwifi driver in
my logs that would suggest that the SYSASSERT mentioned in the commit
message is happening. My hardware is Intel Centrino Advanced-N 6200 (rev
35) (pci_id 8086:422c).

I'll be happy to send any further information if required (Please CC me
in replies).

Thanks and regards.
Kshitij

The full log of the bisection is as follows:

[kulshres@apollo 3.9.y]$ git bisect log
# bad: [57049bb1dd0461d8423c3feceea36148d4335317] Linux 3.9.2
# good: [c1be5a5b1b355d40e6cf79cc979eb66dafa24ad1] Linux 3.9
git bisect start 'HEAD' 'v3.9'
# bad: [50f3a76bf2179283bba925a84839f23fcb42cd92] wireless: regulatory:
fix channel disabling race condition
git bisect bad 50f3a76bf2179283bba925a84839f23fcb42cd92
# bad: [5504e82764f41969a5f4e29af9f950f79ec3538a] crypto: crc32-pclmul -
Use gas macro for pclmulqdq
git bisect bad 5504e82764f41969a5f4e29af9f950f79ec3538a
# bad: [ad3b8a5451b342d58c16806dc6c0f750973c169b] USB: ftdi_sio: correct
ST Micro Connect Lite PIDs
git bisect bad ad3b8a5451b342d58c16806dc6c0f750973c169b
# good: [efaa9d79ccb5491181ea100dc6a9c575f626ef5a] powerpc: Add isync to
copy_and_flush
git bisect good efaa9d79ccb5491181ea100dc6a9c575f626ef5a
# bad: [af1f921702d4074dd61da0d4a2974d51ecd9c05d] mwifiex: Use
pci_release_region() instead of a pci_release_regions()
git bisect bad af1f921702d4074dd61da0d4a2974d51ecd9c05d
# good: [1a36af179e195ab85e1444cc760fd7a620289fa6] powerpc/spufs:
Initialise inode->i_ino in spufs_new_inode()
git bisect good 1a36af179e195ab85e1444cc760fd7a620289fa6
# bad: [c30f37f8f1f8d06c142d67ba74955fd48b5cf5a4] iwlwifi: dvm: don't
send zeroed LQ cmd
git bisect bad c30f37f8f1f8d06c142d67ba74955fd48b5cf5a4
# good: [34e3e78befc3c6f65f3e7ce70f0367745cd550b0] iwlwifi: fix freeing
uninitialized pointer
git bisect good 34e3e78befc3c6f65f3e7ce70f0367745cd550b0


-- 
Dr. Kshitij Kulshreshtha

Institut für Mathematik,
Universität Paderborn,
Warburger Straße 100,
33098 Paderborn.

Büro: A3.235

Privatanschrift:
Arnikaweg 62
33100 Paderborn.
