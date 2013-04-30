Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761046Ab3D3QL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 12:11:58 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:52348 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761019Ab3D3QLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 12:11:55 -0400
Date: Tue, 30 Apr 2013 17:11:47 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Cc: devel@linuxdriverproject.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Hyper-V stalls on device errors
Message-ID: <20130430161146.GA15049@sucs.org>
References: <20130430153321.GA12115@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130430153321.GA12115@sucs.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Apologies for the previous empty mail.

While testing a Windows 2012 host with a Fedora 18 guest running a 3.9
kernel I've found that Hyper-v will stall all access to
(para)virtualised disk devices when an underlying disk device returns an
error. Every ten seconds a tiny bit of I/O goes through before being
stalled again and it plays havoc with asynchronous I/O to disk devices
too.

To produce this I created a device mapper device with a single error in
it by using

dd if=/dev/zero of=/tmp/fakeblock0 bs=100M count=1
losetup --find --show /tmp/fakeblock0
# Assuming losetup uses /dev/loop0
cat << EOF | dmsetup create oneerror
0 13443 linear /dev/loop0 0
13443 1 error
13444 191356 linear /dev/loop0 0
EOF

After installing scsi-target-utils the /dev/mapper/oneerror device was
then turned into a iSCSI target by adding

<target iqn.2013-04.com.stormagic:oneerror>
     backing-store /dev/mapper/oneerror
     write-cache off
</target>

to /etc/tgt/targets.conf . The iSCSI target service was started with
systemctl start tgtd.service (watch out for
https://bugzilla.redhat.com/show_bug.cgi?id=848942 and you may need to
disable the firewall by using systemctl stop firewalld.service ).

The Windows 2012 iSCSI initiator was used to add the target to the
machine with the hypervisor (the usual discovery should work to the
Linux box serving the SCSI target). Once done, this disk was then added
to the Linux guest's Hyper-V settings via the SCSI controller. A spare
IDE controller disk was also added.

In the Linux guest a badblock run was started on the spare IDE disk
block device so that I/O was visible. A 
dd if=/dev/zero of=/dev/sdc oflag=direct
(where /dev/sdc is the erroring block device that was added earlier) was
then done to trigger the access of the bad sector.

The following appeared in dmesg:

[  160.718836] hv_storvsc vmbus_0_12: cmd 0x2a scsi status 0x2 srb status 0x4
[  170.991312] hv_storvsc vmbus_0_12: cmd 0x2a scsi status 0x2 srb status 0x4
[  181.039597] hv_storvsc vmbus_0_12: cmd 0x2a scsi status 0x2 srb status 0x4
[  191.081242] hv_storvsc vmbus_0_12: cmd 0x2a scsi status 0x2 srb status 0x4
[  201.116790] hv_storvsc vmbus_0_12: cmd 0x2a scsi status 0x2 srb status 0x4
[  211.127741] hv_storvsc vmbus_0_12: cmd 0x2a scsi status 0x2 srb status 0x4
[  221.140338] sd 3:0:0:2: [sdc] Unhandled error code
[  221.140346] sd 3:0:0:2: [sdc]  
[  221.140349] Result: hostbyte=DID_OK driverbyte=DRIVER_OK
[  221.140352] sd 3:0:0:2: [sdc] CDB: 
[  221.140354] Write(10): 2a 00 00 00 34 00 00 01 00 00
[  221.140366] end_request: critical target error, dev sdc, sector 13312

A Fedora 18 guest on VMWare ESXi returned the error in under a second
and only had the following in dmesg:

[  293.917383] sd 2:0:1:0: [sdb] Unhandled sense code
[  293.917391] sd 2:0:1:0: [sdb]
[  293.917394] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[  293.917408] sd 2:0:1:0: [sdb]
[  293.917414] Sense Key : Medium Error [current]
[  293.917418] sd 2:0:1:0: [sdb]
[  293.917421] Add. Sense: Unrecovered read error
[  293.917424] sd 2:0:1:0: [sdb] CDB:
[  293.917428] Write(10): 2a 00 00 00 34 00 00 04 00 00
[  293.917436] end_request: critical target error, dev sdb, sector 13312

The stalls do not occur when the bad block device is created directly in
the Linux guest.  From the previous log messages it looks like Hyper-V
is trying for up to a minute before returning an error and the I/O
stalls to separate (but virtualised) devices on different buses looks
like an unintended side effect...

-- 
Sitsofe | http://sucs.org/~sits/
