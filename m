Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbaA3UyN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 15:54:13 -0500
Received: from infra.glanzmann.de ([88.198.249.254]:47464 "EHLO
	infra.glanzmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbaA3UyL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 15:54:11 -0500
X-Greylist: delayed 585 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Jan 2014 15:54:11 EST
Date: Thu, 30 Jan 2014 21:44:24 +0100
From: Thomas Glanzmann <thomas@glanzmann.de>
To: discuss@openvswitch.org, LKML <linux-kernel@vger.kernel.org>
Subject: Linus GIT Head OOPs reproducable in open vswitch when running
 mininet topology
Message-ID: <20140130204424.GB19093@glanzmann.de>
Mail-Followup-To: Thomas Glanzmann <thomas@glanzmann.de>,
	discuss@openvswitch.org, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
open vswitch git head with Linus tip OOPses for me reproducable when I
load the following mininet topology:

(lenovo) [~/work/linux-2.6] git log | head -1
commit 9b0cd304f26b9fca140de15deeac2bf357d1f388
(lenovo) [~/work/openvswitch] git log | head -1
commit 0a8763fcb31bfca0d8d854c235c531005088fcb9

Howto reproduce:
cat > mininet_sample_topo.py <<EOF
from mininet.topo import Topo

class SampleTopo( Topo ):
    "Simple topology"

    def __init__( self ):
        "Create custom topo."

        # Initialize topology
        Topo.__init__( self )

        # Add hosts
        h1= self.addHost( 'h1' )
        h2= self.addHost( 'h2' )
        h3= self.addHost( 'h3' )
        h4= self.addHost( 'h4' )
        h5= self.addHost( 'h5' )
        h6= self.addHost( 'h6' )
        h7= self.addHost( 'h7' )
        h8= self.addHost( 'h8' )
        h9= self.addHost( 'h9' )

        # Switches
        s1= self.addSwitch( 's1' )
        s2= self.addSwitch( 's2' )
        s3= self.addSwitch( 's3' )
        s4= self.addSwitch( 's4' )

        # Add links
        self.addLink( s1, h1 )
        self.addLink( s1, h2 )
        self.addLink( s3, s4 )

        self.addLink( h3, s2 )
        self.addLink( h4, s2 )

        self.addLink( h5, s3 )
        self.addLink( h6, s3 )

        self.addLink( s1, s2 )
        self.addLink( s1, s3 )
        self.addLink( s2, s4 )

        self.addLink( s4, h7 )
        self.addLink( s4, h8 )
        self.addLink( s4, h9 )

topos = { 'sampletopo': ( lambda: SampleTopo() ) }
EOF

mn -v debug --custom mininet_sample_topo.py --topo sampletopo --mac --switch ovsk --arp --controller remote,ip=localhost
Output:
http://pbot.rmdir.de/ptk5-vuy16pLBJGdDSE5JQ

Complete DMESG:
http://pbot.rmdir.de/fD65sAlc49BT-KC5SFRO4g

Kernel Config:
http://pbot.rmdir.de/lEDS-D8yloQbp8TIpGRoIA

[   38.389203] BUG: unable to handle kernel NULL pointer dereference at 00000000000000a8
[   38.389320] IP: [<ffffffff812ddb76>] if_nlmsg_size+0x144/0x1bc
[   38.389405] PGD b5e35067 PUD b5457067 PMD 0
[   38.389471] Oops: 0000 [#1] SMP
[   38.389521] Modules linked in: veth xt_tcpudp iptable_mangle xt_mark ip_tables x_tables openvswitch gre libcrc32c autofs4 deflate ctr twofish_generic twofish_x86_64_3way xts twofish_x86_64 twofish_common camellia_generic serpent_generic blowfish_generic blowfish_x86_64 blowfish_common cast5_generic cast_common des_generic cbc cmac xcbc rmd160 sha512_generic sha256_generic hmac crypto_null af_key xfrm_algo nfsd auth_rpcgss oid_registry nfs_acl nfs lockd fscache sunrpc fuse loop qcserial usb_wwan usbserial btusb bluetooth 6lowpan_iphc hid_generic usbhid hid snd_usb_audio snd_usbmidi_lib snd_hda_codec_hdmi snd_hda_codec_conexant snd_hda_codec_generic coretemp kvm_intel kvm arc4 crc32c_intel snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss ghash_clmulni_intel thinkpad_acpi nvram snd_mixer_oss snd_pcm iwldvm mac80211 snd_seq_midi aesni_intel snd_seq_midi_event snd_rawmidi aes_x86_64 ablk_helper cryptd lrw tpm_tis iwlwifi gf128mul tpm parport_pc snd_seq mxm_wmi snd_timer cfg80211 wmi acpi_cpufreq battery intel_ips i915 drm_kms_helper drm iTCO_wdt iTCO_vendor_support snd_seq_device ac snd rfkill soundcore glue_helper i2c_i801 i2c_algo_bit evdev psmouse i2c_core serio_raw pcspkr lpc_ich video ehci_pci ehci_hcd mfd_core usbcore parport usb_common button processor ext4 crc16 jbd2 mbcache sg sd_mod sr_mod crc_t10dif cdrom crct10dif_common ahci libahci libata thermal thermal_sys microcode sdhci_pci sdhci mmc_core scsi_mod e1000e ptp pps_core
[   38.391442] CPU: 0 PID: 5058 Comm: ovs-vswitchd Not tainted 3.13.0+ #56
[   38.391508] Hardware name: LENOVO 2912W1C/2912W1C, BIOS 6UET70WW (1.50 ) 10/11/2012
[   38.391610] task: ffff880132a96de0 ti: ffff8800b504e000 task.ti: ffff8800b504e000
[   38.391694] RIP: 0010:[<ffffffff812ddb76>]  [<ffffffff812ddb76>] if_nlmsg_size+0x144/0x1bc
[   38.391802] RSP: 0018:ffff8800b504f898  EFLAGS: 00210286
[   38.391871] RAX: ffff8800b4da3000 RBX: ffff880036d1a000 RCX: 0000000000000014
[   38.391957] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff880036d1a000
[   38.392052] RBP: 0000000000000014 R08: 0000000000000000 R09: ffffffff8167c010
[   38.392139] R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
[   38.392235] R13: ffffffffa080b000 R14: 0000000000000000 R15: 0000000000000007
[   38.392327] FS:  0000000000000000(0000) GS:ffff880137c00000(0063) knlGS:00000000f7318ac0
[   38.392417] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[   38.392474] CR2: 00000000000000a8 CR3: 00000000b50af000 CR4: 00000000000007f0
[   38.392542] Stack:
[   38.392564]  ffff880132f86538 0000000000000004 0000000000000000 00000000ffffffff
[   38.392646]  ffff880036d1a000 ffffffff8167a580 00000000000000d0 0000000000000010
[   38.392728]  ffffffffa07e5201 ffffffff812e0220 ffff8800b4da3000 ffff880036d1a000
[   38.392810] Call Trace:
[   38.392842]  [<ffffffff812e0220>] ? rtmsg_ifinfo+0x2a/0xd6
[   38.392898]  [<ffffffff812e02f9>] ? rtnetlink_event+0x2d/0x31
[   38.392957]  [<ffffffff81390420>] ? notifier_call_chain+0x2e/0x59
[   38.393019]  [<ffffffff812cf254>] ? call_netdevice_notifiers+0xe/0x13
[   38.393084]  [<ffffffff812d48c4>] ? __netdev_upper_dev_link+0x1c8/0x2d3
[   38.393149]  [<ffffffff812cf918>] ? dev_name_hash.isra.63+0x20/0x35
[   38.393215]  [<ffffffffa07e476a>] ? netdev_create+0x94/0x126 [openvswitch]
[   38.393284]  [<ffffffffa07e3f4b>] ? ovs_vport_add+0x18/0x6d [openvswitch]
[   38.393352]  [<ffffffffa07ddcbc>] ? new_vport+0x9/0x43 [openvswitch]
[   38.393417]  [<ffffffffa07dfba2>] ? ovs_vport_cmd_new+0x102/0x167 [openvswitch]
[   38.393490]  [<ffffffff812f68fa>] ? genl_family_rcv_msg+0x235/0x2a2
[   38.393552]  [<ffffffff812f699f>] ? genl_rcv_msg+0x38/0x5b
[   38.393608]  [<ffffffff812c6cc4>] ? __kmalloc_reserve.isra.42+0x2a/0x6d
[   38.393673]  [<ffffffff812f6967>] ? genl_family_rcv_msg+0x2a2/0x2a2
[   38.393736]  [<ffffffff812f57fb>] ? netlink_rcv_skb+0x36/0x7c
[   38.393793]  [<ffffffff812f59c6>] ? genl_rcv+0x1f/0x2c
[   38.393844]  [<ffffffff812f52bf>] ? netlink_unicast+0xff/0x17f
[   38.393903]  [<ffffffff812f5623>] ? netlink_sendmsg+0x2e4/0x312
[   38.393963]  [<ffffffff812c0a5b>] ? sock_sendmsg+0x49/0x64
[   38.394018]  [<ffffffff812d61e0>] ? ethtool_get_value+0x32/0x4a
[   38.394077]  [<ffffffff812d7831>] ? dev_ethtool+0xcdd/0x14c4
[   38.394135]  [<ffffffff811153d5>] ? full_name_hash+0x13/0x50
[   38.394192]  [<ffffffff811153d5>] ? full_name_hash+0x13/0x50
[   38.394249]  [<ffffffff812eaec3>] ? verify_compat_iovec+0x68/0xb1
[   38.394309]  [<ffffffff812c0c56>] ? ___sys_sendmsg+0x1e0/0x25a
[   38.397548]  [<ffffffff812e2d70>] ? dev_ioctl+0x45d/0x5a9
[   38.400743]  [<ffffffff810676d9>] ? __wake_up+0x35/0x46
[   38.403927]  [<ffffffff812bf520>] ? compat_sock_ioctl+0x53d/0xa53
[   38.407127]  [<ffffffff812bfc83>] ? move_addr_to_user+0x5f/0x90
[   38.410238]  [<ffffffff8110f1b0>] ? fput+0xd/0x82
[   38.413228]  [<ffffffff812c15da>] ? __sys_sendmsg+0x39/0x57
[   38.416123]  [<ffffffff812eb8e0>] ? compat_sys_socketcall+0x145/0x19d
[   38.418933]  [<ffffffff81393bb5>] ? sysenter_dispatch+0x7/0x1a
[   38.421625] Code: 45 68 48 85 c0 74 10 48 89 df ff d0 83 c0 07 83 e0 fc 48 98 48 01 c5 48 89 df e8 0d 13 ff ff 48 85 c0 74 21 48 8b 90 08 07 00 00 <48> 8b 92 a8 00 00 00 48 85 d2 74 0e 48 89 de 48 89 c7 ff d2 48
[   38.427445] RIP  [<ffffffff812ddb76>] if_nlmsg_size+0x144/0x1bc
[   38.430162]  RSP <ffff8800b504f898>
[   38.432962] CR2: 00000000000000a8
[   38.456280] ---[ end trace 6e07d7de8b97f35f ]---

Cheers,
        Thomas
