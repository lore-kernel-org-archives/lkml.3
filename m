Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836Ab3CFXbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 18:31:06 -0500
Received: from fep03.xtra.co.nz ([210.54.141.243]:29395 "EHLO fep02.xtra.co.nz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752869Ab3CFXbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 18:31:05 -0500
From: "Ivo Tisch" <ivo@pretech.co.nz>
To: <linux-kernel@vger.kernel.org>
Subject: Wifi AP with rt3072 USB dongle -- intermittently unresponsive
Date: Thu, 7 Mar 2013 12:07:52 +1300
Message-ID: <018a01ce1abf$7dcff720$796fe560$@co.nz>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Ac4av221dw9sCIjDRX+2KlW4x4fW9g==
Content-Language: en-nz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have both a Raspberry Pi (BCM2835 SoC) and a Beagleboard-xm (OMAP3525/30
SoC),
set up as access points (rt3072 wifi dongle), which are for the most 
very responsive. However, periodically the AP becomes unresponsive for 
up to 20 seconds- on both platforms. 
Most of my testing has been done on the Raspberry Pi, but because that has
some
issues with its usb-otg system, I obtained the Beagleboard for comparison
tests.
The configuration I use for testing is: The AP connected to one client
(windows XP
Laptop), running an ssh session on the AP. Top is running in the ssh session
to generate some traffic and processor load. Concurrently, the laptop is
pinging
the AP to test delays in response.
In general, with low traffic volume (top -d 2), ping responses are 2-3ms 
on either host. After 5-20 minutes, data over the link will freeze and pings
will
simultaneously timeout.  The duration of the freeze depends on whether the
AP is
in n or g mode.  In g mode the freeze is about 4 secs; in n, it is about
12-20
secs. The probability of a freeze occurring increases with traffic over the
link.
At 20kB/s, the interval between freezes is around 15 mins; whereas at
60-70kB/s 
the freezes occur every 5-60 secs. It is particularly bad with HT/WMM
enabled.
If a concurrent top session is run via the Ethernet port, there are
no freezes in _that_ link, and changes to its top period have no affect on
the 
freezes occurring on the AP link. This appears to rule out the processor
loading effect of top.  
I have tried the same dongle on the Rasp Pi configured as a normal wifi
client,
and if power saving is switched off, it performs very well. If power saving
is left
on, I also experience very occasional 4 second freezes and very erratic ping
times.
I have also tried the same AP setup on an x86_64 host. This performed much
better
with WMM enabled, but I still got three 4 second timeouts in a couple of
hours
and several high ping durations between 900 - 1093ms which I wouldn't have
expected from a very lightly loaded system.
Other Raspberry Pi users report their APs working well with other dongle
chips -
in particular the rt5370 which is using the same rt2800usb driver, but I
cannot
say how methodical they have been with their testing.  
I have a preference for a high power AP using the rt3072 and I would really
like to 
see a solution.
During the freezes, there were no posts to syslog or dmesg.
The physical dongle in use: Digitech computer, High-Power, wireless-N, USB
adapter.

uname -a
raspberry pi:
Linux raspberrypi 3.6.11+ #389 PREEMPT Wed Mar 6 12:43:30 GMT 2013 armv6l
GNU/Linux
and many previous releases.
Beagleboard:
Linux ivobeagle 3.2.0-38-omap #61-Ubuntu Tue Feb 19 12:23:10 UTC 2013 armv7l
armv7l 
armv7l GNU/Linux
X86 host:
Linux ubuntu 3.5.0-25-generic #39-Ubuntu SMP Mon Feb 25 18:26:58 UTC 2013
x86_64 x86_64 x86_64 GNU/Linux

All three AP hosts used the same /etc/default/hostapd,
/etc/hostapd/hostapd.conf,
/etc/dnsmasq.conf, /etc/network/interfaces.

********************************
hostapd.conf:

interface=wlan0
driver=nl80211
ctrl_interface_group=0
ssid=*******

hw_mode=g
ieee80211n=1
wmm_enabled=1

channel=5
auth_algs=3
wpa=3
wpa_passphrase=*******
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP

ht_capab=[HT20][SHORT-GI-20] #[RX-STBC1]

#eapol_key_index_workaround=0

**********************************
Raspberry pi lsmod:
Module                  Size  Used by
aes_generic            31536  1
8021q                  17966  0
garp                    6295  1 8021q
stp                     1969  1 garp
llc                     5440  2 stp,garp
snd_bcm2835            15846  0
snd_pcm                77560  1 snd_bcm2835
snd_page_alloc          5145  1 snd_pcm
snd_seq                53329  0
snd_seq_device          6438  1 snd_seq
snd_timer              19998  2 snd_pcm,snd_seq
snd                    58447  5
snd_bcm2835,snd_timer,snd_pcm,snd_seq,snd_seq_device
arc4                    1676  2
rt2800usb              14940  0
rt2800lib              55351  1 rt2800usb
rt2x00usb              11215  1 rt2800usb
rt2x00lib              42334  3 rt2x00usb,rt2800lib,rt2800usb
mac80211              273413  3 rt2x00lib,rt2x00usb,rt2800lib
cfg80211              184163  2 mac80211,rt2x00lib
rfkill                 18202  2 cfg80211
crc_ccitt               1522  1 rt2800lib
evdev                   9426  2
joydev                  9316  0
leds_gpio               2235  0
led_class               3562  2 leds_gpio,rt2x00lib

*************************************************
Beagleboard lsmod:

Module                  Size  Used by
dm_crypt               15586  0
arc4                    1239  2
rt2800usb              11277  0
rt2800lib              48198  1 rt2800usb
crc_ccitt               1509  1 rt2800lib
rt2x00usb              11523  1 rt2800usb
rt2x00lib              52423  3 rt2800usb,rt2800lib,rt2x00usb
mac80211              435767  3 rt2800lib,rt2x00usb,rt2x00lib
cfg80211              180757  2 rt2x00lib,mac80211
smsc95xx               12427  0
usbnet                 17830  1 smsc95xx
dm_multipath           16249  0
twl4030_madc_hwmon      2593  0
snd_soc_twl4030        37838  0
snd_soc_core          111406  1 snd_soc_twl4030
omap_wdt                4191  0
snd_pcm                73736  2 snd_soc_twl4030,snd_soc_core
snd_timer              20110  1 snd_pcm
snd                    60342  3 snd_soc_core,snd_pcm,snd_timer
twl4030_madc            6968  1 twl4030_madc_hwmon
soundcore               7337  1 snd
twl4030_pwrbutton       1245  0
snd_page_alloc          4999  1 snd_pcm
spi_omap2_mcspi         8232  0
gpio_keys               7445  0
leds_gpio               3441  0
dm_mirror              13449  0
dm_region_hash         10178  1 dm_mirror
dm_log                  9519  2 dm_mirror,dm_region_hash
btrfs                 672215  0
zlib_deflate           21728  1 btrfs
libcrc32c               1233  1 btrfs

***************************************
ivo@ivobeagle:~$ iw wlan0 station dump

Station 00:21:6a:26:42:7e (on wlan0)
        inactive time:  609 ms
        rx bytes:       30624
        rx packets:     455
        tx bytes:       13879
        tx packets:     135
        tx retries:     1
        tx failed:      0
        signal:         -29 dBm
        signal avg:     -31 dBm
        tx bitrate:     65.0 MBit/s MCS 7
        authorized:     yes
        authenticated:  yes
        preamble:       long
        WMM/WME:        yes
        MFP:            no

*****************************************

Example from either rasp pi or beagleboard showing
consistency of ping interspersed with random 
freezes: ping interval ~ 1sec/timeout~4 sec

Reply from 192.168.0.1: bytes=32 time=1ms TTL=64
Reply from 192.168.0.1: bytes=32 time<1ms TTL=64
Reply from 192.168.0.1: bytes=32 time=1ms TTL=64
Reply from 192.168.0.1: bytes=32 time<1ms TTL=64
Reply from 192.168.0.1: bytes=32 time<1ms TTL=64
Reply from 192.168.0.1: bytes=32 time=1ms TTL=64
Reply from 192.168.0.1: bytes=32 time=1ms TTL=64
Reply from 192.168.0.1: bytes=32 time=1ms TTL=64
Reply from 192.168.0.1: bytes=32 time=1ms TTL=64
Reply from 192.168.0.1: bytes=32 time=5ms TTL=64
Reply from 192.168.0.1: bytes=32 time<1ms TTL=64
Reply from 192.168.0.1: bytes=32 time=1ms TTL=64
Request timed out.
Request timed out.
Request timed out.
Request timed out.
Reply from 192.168.0.1: bytes=32 time<1ms TTL=64
Reply from 192.168.0.1: bytes=32 time<1ms TTL=64
Reply from 192.168.0.1: bytes=32 time<1ms TTL=64
Reply from 192.168.0.1: bytes=32 time<1ms TTL=64
Reply from 192.168.0.1: bytes=32 time<1ms TTL=64
Reply from 192.168.0.1: bytes=32 time=1ms TTL=64
Reply from 192.168.0.1: bytes=32 time<1ms TTL=64
Reply from 192.168.0.1: bytes=32 time=1ms TTL=64
Reply from 192.168.0.1: bytes=32 time=1ms TTL=64
Reply from 192.168.0.1: bytes=32 time=1ms TTL=64
Reply from 192.168.0.1: bytes=32 time<1ms TTL=64
Reply from 192.168.0.1: bytes=32 time<1ms TTL=64
Reply from 192.168.0.1: bytes=32 time=1ms TTL=64
Reply from 192.168.0.1: bytes=32 time=1ms TTL=64

I am a new Linux user, but am keen to learn and do my part to uncover
the problem. I will need some pointing in the right direction though.

I would also like to ask why ping times on both platforms are 
Typically 2-3ms with virtually no traffic on the single ssh session, 
but they improve to around 1ms when there is a reasonable volume of 
traffic 50+ kB/s? It seems counter-intuitive. Does something in the 
driver adapt to the increased traffic?

Thanks all for your fantastic work.

regards

Ivo
ivo@pretech.co.nz

