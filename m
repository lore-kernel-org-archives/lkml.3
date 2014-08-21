Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaHUQVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:21:17 -0400
Received: from smtp.outflux.net ([198.145.64.163]:60767 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbaHUQVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:21:15 -0400
Date: Thu, 21 Aug 2014 09:20:50 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>
Subject: [PATCH] checkpatch: look for common misspellings
Message-ID: <20140821162050.GA1323@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check for misspellings, based on Debian's lintian list. Several false
positives were removed, and several additional words added that were
common in the kernel:

	backword backwords
	invalide valide
	recieves
	singed unsinged

While going back and fixing existing spelling mistakes isn't a high
priority, it'd be nice to try to catch them before they hit the tree.

Between 3.15 and 3.16-rc7, the script would have noticed the following 46
mistakes:

      6 prefered
      6 endianess
      5 recieve
      4 changable
      3 sytem
      3 synchonized
      3 splitted
      3 informations
      2 unconditionaly
      2 sucessfully
      2 seperate
      2 recieved
      2 preceeding
      2 paramters
      2 managment
      2 fuction
      2 accesing
      1 writting
      1 targetting
      1 syncronize
      1 supress
      1 succesful
      1 specifed
      1 serveral
      1 repectively
      1 registerd
      1 paramter
      1 overriden
      1 neccessary
      1 lenght
      1 intial
      1 initalize
      1 dependant
      1 dependancy
      1 correspoding
      1 correponds
      1 contraints
      1 compatibilty
      1 childs
      1 begining
      1 becomming
      1 bandwith
      1 availble
      1 amoung
      1 alot
      1 addreses

For additional context, here are the top 15 spelling mistakes in the entire
tree:

    131 informations
     96 ressize
     80 prefered
     68 endianess
     61 transfered
     60 childs
     59 overriden
     55 treshold
     46 capabilites
     40 splitted
     39 commited
     33 continous
     31 ouput
     29 lenght
     29 explicitely

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 MAINTAINERS           |   1 +
 scripts/checkpatch.pl |  37 +++-
 scripts/spelling.txt  | 595 ++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 632 insertions(+), 1 deletion(-)
 create mode 100644 scripts/spelling.txt

diff --git a/MAINTAINERS b/MAINTAINERS
index aefa94841ff3..b20d7bde5403 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2311,6 +2311,7 @@ M:	Andy Whitcroft <apw@canonical.com>
 M:	Joe Perches <joe@perches.com>
 S:	Maintained
 F:	scripts/checkpatch.pl
+F:	scripts/spelling.txt
 
 CHINESE DOCUMENTATION
 M:	Harry Wei <harryxiyou@gmail.com>
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 31a731e06f50..8a338e2a5a59 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -9,7 +9,8 @@ use strict;
 use POSIX;
 
 my $P = $0;
-$P =~ s@.*/@@g;
+$P =~ s@(.*)/@@g;
+my $D = $1;
 
 my $V = '0.32';
 
@@ -43,6 +44,7 @@ my $configuration_file = ".checkpatch.conf";
 my $max_line_length = 80;
 my $ignore_perl_version = 0;
 my $minimum_perl_version = 5.10.0;
+my $spelling_file = "$D/spelling.txt";
 
 sub help {
 	my ($exitcode) = @_;
@@ -429,6 +431,32 @@ our $allowed_asm_includes = qr{(?x:
 )};
 # memory.h: ARM has a custom one
 
+# Load common spelling mistakes and build regular expression list.
+my $spelling_re;
+my @spelling_list;
+my %spelling_fix;
+open(my $spelling, '<', $spelling_file)
+    or die "$P: Can't open $spelling_file for reading: $!\n";
+while (<$spelling>) {
+	my $line = $_;
+
+	$line =~ s/\s*\n?$//g;
+	$line =~ s/^\s*//g;
+
+	next if ($line =~ m/^\s*#/);
+	next if ($line =~ m/^\s*$/);
+
+	my ($suspect, $fix) = split(/\|\|/, $line);
+
+	push(@spelling_list, $suspect);
+	$spelling_fix{$suspect} = $fix;
+}
+close($spelling);
+# $edge can't be "\b" because that includes things like "_". And we should
+# not treat "@" as a boundary so we don't trip on email addresses.
+my $edge = "[^[:alpha:]@]";
+$spelling_re = "(?:^|$edge)(" . join("|", @spelling_list) . ")(?:\$|$edge)";
+
 sub build_types {
 	my $mods = "(?x:  \n" . join("|\n  ", @modifierList) . "\n)";
 	my $all = "(?x:  \n" . join("|\n  ", @typeList) . "\n)";
@@ -5048,6 +5076,13 @@ sub process {
 				}
 			}
 		}
+
+# Check for several spelling mistakes.
+		if ($rawline =~ $spelling_re) {
+			my $typo = "The word '$1' may be misspelled";
+			$typo .= " (perhaps you want '$spelling_fix{$1}'?)\n";
+			WARN("TYPO_SPELLING", $typo . $herecurr);
+		}
 	}
 
 	# If we have no input at all, then there is nothing to report on
diff --git a/scripts/spelling.txt b/scripts/spelling.txt
new file mode 100644
index 000000000000..03c6234464ee
--- /dev/null
+++ b/scripts/spelling.txt
@@ -0,0 +1,595 @@
+# Originally from Debian's Lintian tool. Various false positives have been
+# removed, and various additions have been made as they've been discovered
+# in the kernel source.
+#
+# License: GPLv2
+#
+# The format of each line is:
+# mistake||correction
+#
+abandonning||abandoning
+abigious||ambiguous
+abitrate||arbitrate
+abov||above
+absense||absence
+absolut||absolute
+absoulte||absolute
+acceleratoin||acceleration
+accelleration||acceleration
+accesing||accessing
+accesnt||accent
+accessable||accessible
+accesss||access
+accidentaly||accidentally
+accidentually||accidentally
+accomodate||accommodate
+accomodates||accommodates
+accout||account
+acessable||accessible
+acess||access
+acient||ancient
+acknowldegement||acknowldegement
+ackowledge||acknowledge
+ackowledged||acknowledged
+acording||according
+activete||activate
+acumulating||accumulating
+addional||additional
+additionaly||additionally
+addreses||addresses
+aditional||additional
+aditionally||additionally
+aditionaly||additionally
+adress||address
+adresses||addresses
+adviced||advised
+afecting||affecting
+albumns||albums
+alegorical||allegorical
+algorith||algorithm
+algorithmical||algorithmically
+algoritm||algorithm
+algoritms||algorithms
+algorrithm||algorithm
+algorritm||algorithm
+allpication||application
+alogirhtms||algorithms
+alot||a lot
+alow||allow
+alows||allows
+altough||although
+ambigious||ambiguous
+amoung||among
+amout||amount
+analysator||analyzer
+ang||and
+anniversery||anniversary
+annoucement||announcement
+anomolies||anomalies
+anomoly||anomaly
+aplication||application
+appearence||appearance
+appliction||application
+applictions||applications
+appropiate||appropriate
+appropriatly||appropriately
+aquired||acquired
+arbitary||arbitrary
+architechture||architecture
+arguement||argument
+arguements||arguments
+aritmetic||arithmetic
+arne't||aren't
+arraival||arrival
+artifical||artificial
+artillary||artillery
+assigment||assignment
+assigments||assignments
+assistent||assistant
+asuming||assuming
+asycronous||asynchronous
+atomatically||automatically
+attachement||attachment
+attemps||attempts
+attruibutes||attributes
+authentification||authentication
+automaticaly||automatically
+automaticly||automatically
+automatize||automate
+automatized||automated
+automatizes||automates
+autonymous||autonomous
+auxilliary||auxiliary
+avaiable||available
+availabled||available
+availablity||availability
+availale||available
+availavility||availability
+availble||available
+availble||available
+availiable||available
+avaliable||available
+avaliable||available
+backgroud||background
+backword||backward
+backwords||backwards
+bahavior||behavior
+baloon||balloon
+baloons||balloons
+bandwith||bandwidth
+batery||battery
+becomming||becoming
+becuase||because
+begining||beginning
+bianries||binaries
+calender||calendar
+cancelation||cancellation
+capabilites||capabilities
+capatibilities||capabilities
+cariage||carriage
+challange||challenge
+challanges||challenges
+changable||changeable
+charachter||character
+charachters||characters
+charater||character
+charaters||characters
+charcter||character
+childs||children
+chnage||change
+chnages||changes
+choosen||chosen
+collapsable||collapsible
+colorfull||colorful
+comand||command
+comit||commit
+commerical||commercial
+comminucation||communication
+commited||committed
+commiting||committing
+committ||commit
+commoditiy||commodity
+compability||compatibility
+compatability||compatibility
+compatable||compatible
+compatibiliy||compatibility
+compatibilty||compatibility
+compilant||compliant
+compleatly||completely
+completly||completely
+complient||compliant
+compres||compress
+compresion||compression
+comression||compression
+conditionaly||conditionally
+configuratoin||configuration
+conjuction||conjunction
+connectinos||connections
+connnection||connection
+connnections||connections
+consistancy||consistency
+consistant||consistent
+containes||contains
+containts||contains
+contaisn||contains
+contence||contents
+continous||continuous
+continously||continuously
+continueing||continuing
+contraints||constraints
+convertor||converter
+convinient||convenient
+corected||corrected
+correponding||corresponding
+correponds||corresponds
+correspoding||corresponding
+cryptocraphic||cryptographic
+curently||currently
+dafault||default
+deafult||default
+deamon||daemon
+decompres||decompress
+definate||definite
+definately||definitely
+delared||declared
+delare||declare
+delares||declares
+delaring||declaring
+delemiter||delimiter
+dependancies||dependencies
+dependancy||dependency
+dependant||dependent
+depreacted||deprecated
+depreacte||deprecate
+desactivate||deactivate
+detabase||database
+developement||development
+developped||developed
+developpement||development
+developper||developer
+developpment||development
+deveolpment||development
+devided||divided
+dictionnary||dictionary
+diplay||display
+disapeared||disappeared
+dispertion||dispersion
+dissapears||disappears
+docuentation||documentation
+documantation||documentation
+documentaion||documentation
+downlad||download
+downlads||downloads
+easilly||easily
+ecspecially||especially
+edditable||editable
+editting||editing
+efficently||efficiently
+eletronic||electronic
+enchanced||enhanced
+encorporating||incorporating
+endianess||endianness
+enhaced||enhanced
+enlightnment||enlightenment
+enocded||encoded
+enterily||entirely
+enviroiment||environment
+enviroment||environment
+environement||environment
+environent||environment
+equiped||equipped
+equivelant||equivalent
+equivilant||equivalent
+estbalishment||establishment
+etsablishment||establishment
+etsbalishment||establishment
+excecutable||executable
+exceded||exceeded
+excellant||excellent
+exlcude||exclude
+exlcusive||exclusive
+expecially||especially
+explicitely||explicitly
+explict||explicit
+explictly||explicitly
+expresion||expression
+exprimental||experimental
+extensability||extensibility
+extention||extension
+extracter||extractor
+failuer||failure
+familar||familiar
+fatser||faster
+feauture||feature
+feautures||features
+fetaure||feature
+fetaures||features
+forse||force
+fortan||fortran
+forwardig||forwarding
+framwork||framework
+fuction||function
+fuctions||functions
+functionallity||functionality
+functionaly||functionally
+functionnality||functionality
+functonality||functionality
+futhermore||furthermore
+generiously||generously
+grabing||grabbing
+grahical||graphical
+grahpical||graphical
+grapic||graphic
+guage||gauge
+halfs||halves
+handfull||handful
+heirarchically||hierarchically
+helpfull||helpful
+hierachy||hierarchy
+hierarchie||hierarchy
+howver||however
+immeadiately||immediately
+implemantation||implementation
+implemention||implementation
+incomming||incoming
+incompatabilities||incompatibilities
+incompatable||incompatible
+inconsistant||inconsistent
+indendation||indentation
+indended||intended
+independant||independent
+independed||independent
+informatiom||information
+informations||information
+infromation||information
+initalize||initialize
+initators||initiators
+initializiation||initialization
+inofficial||unofficial
+integreated||integrated
+integrety||integrity
+integrey||integrity
+intendet||intended
+interchangable||interchangeable
+intermittant||intermittent
+interupted||interrupted
+intial||initial
+intregral||integral
+intuative||intuitive
+invalde||invald
+invokation||invocation
+invokations||invocations
+jave||java
+langage||language
+langauage||language
+langauge||language
+langugage||language
+lauch||launch
+leightweight||lightweight
+lenght||length
+lesstiff||lesstif
+libaries||libraries
+libary||library
+librairies||libraries
+libraris||libraries
+licenceing||licencing
+loggging||logging
+loggin||login
+logile||logfile
+machinary||machinery
+maintainance||maintenance
+maintainence||maintenance
+maintan||maintain
+makeing||making
+malplaced||misplaced
+malplace||misplace
+managable||manageable
+managment||management
+manoeuvering||maneuvering
+mathimatical||mathematical
+mathimatic||mathematic
+mathimatics||mathematics
+ment||meant
+messsage||message
+messsages||messages
+microprocesspr||microprocessor
+milliseonds||milliseconds
+miscelleneous||miscellaneous
+misformed||malformed
+mispelled||misspelled
+mispelt||misspelt
+mmnemonic||mnemonic
+modulues||modules
+monochorome||monochrome
+monochromo||monochrome
+monocrome||monochrome
+mroe||more
+mulitplied||multiplied
+multidimensionnal||multidimensional
+mutiple||multiple
+nam||name
+nams||names
+navagating||navigating
+nead||need
+neccesary||necessary
+neccessary||necessary
+necesary||necessary
+negotation||negotiation
+nescessary||necessary
+nessessary||necessary
+noticable||noticeable
+notications||notifications
+occationally||occasionally
+omitt||omit
+ommitted||omitted
+onself||oneself
+optionnal||optional
+optmizations||optimizations
+orientatied||orientated
+orientied||oriented
+ouput||output
+overaall||overall
+overriden||overridden
+pacakge||package
+pachage||package
+packacge||package
+packege||package
+packge||package
+pakage||package
+pallette||palette
+paramameters||parameters
+paramater||parameter
+parametes||parameters
+parametised||parametrised
+paramter||parameter
+paramters||parameters
+particularily||particularly
+pased||passed
+pendantic||pedantic
+peprocessor||preprocessor
+perfoming||performing
+permissons||permissions
+persistant||persistent
+plattform||platform
+pleaes||please
+ploting||plotting
+poinnter||pointer
+posible||possible
+possibilites||possibilities
+powerfull||powerful
+preceeded||preceded
+preceeding||preceding
+precendence||precedence
+precission||precision
+prefered||preferred
+prefferably||preferably
+prepaired||prepared
+primative||primitive
+princliple||principle
+priorty||priority
+priviledge||privilege
+priviledges||privileges
+procceed||proceed
+proccesors||processors
+proces||process
+processessing||processing
+processess||processes
+processpr||processor
+processsing||processing
+progams||programs
+programers||programmers
+programm||program
+programms||programs
+promps||prompts
+pronnounced||pronounced
+prononciation||pronunciation
+pronouce||pronounce
+pronunce||pronounce
+propery||property
+propigate||propagate
+propigation||propagation
+prosess||process
+protable||portable
+protcol||protocol
+protecion||protection
+protocoll||protocol
+psychadelic||psychedelic
+quering||querying
+reasearcher||researcher
+reasearchers||researchers
+reasearch||research
+recieved||received
+recieve||receive
+reciever||receiver
+recieves||receives
+recogniced||recognised
+recognizeable||recognizable
+recommanded||recommended
+redircet||redirect
+redirectrion||redirection
+refence||reference
+registerd||registered
+registraration||registration
+regulamentations||regulations
+remoote||remote
+removeable||removable
+repectively||respectively
+replacments||replacements
+replys||replies
+requiere||require
+requred||required
+requried||required
+resizeable||resizable
+ressize||resize
+ressource||resource
+ressources||resources
+retransmited||retransmitted
+retreive||retrieve
+retreived||retrieved
+rmeoved||removed
+rmeove||remove
+rmeoves||removes
+runned||ran
+runnning||running
+sacrifying||sacrificing
+safly||safely
+savable||saveable
+searchs||searches
+secund||second
+separatly||separately
+sepcify||specify
+seperated||separated
+seperately||separately
+seperate||separate
+seperatly||separately
+seperator||separator
+sepperate||separate
+sequencial||sequential
+serveral||several
+setts||sets
+similiar||similar
+simliar||similar
+singed||signed
+softwares||software
+speach||speech
+speciefied||specified
+specifed||specified
+specificatin||specification
+specificaton||specification
+specifing||specifying
+speficied||specified
+speling||spelling
+splitted||split
+spreaded||spread
+staically||statically
+standardss||standards
+standart||standard
+staticly||statically
+subdirectoires||subdirectories
+suble||subtle
+succesfully||successfully
+succesful||successful
+sucessfully||successfully
+superflous||superfluous
+superseeded||superseded
+suplied||supplied
+suport||support
+suppored||supported
+supportin||supporting
+suppoted||supported
+suppported||supported
+suppport||support
+supress||suppress
+surpresses||suppresses
+suspicously||suspiciously
+synax||syntax
+synchonized||synchronized
+syncronize||synchronize
+syncronizing||synchronizing
+syncronus||synchronous
+syste||system
+sytem||system
+sythesis||synthesis
+taht||that
+targetted||targeted
+targetting||targeting
+teh||the
+throught||through
+transfered||transferred
+transfering||transferring
+trasmission||transmission
+treshold||threshold
+trigerring||triggering
+unconditionaly||unconditionally
+unecessary||unnecessary
+unexecpted||unexpected
+unfortunatelly||unfortunately
+unknonw||unknown
+unkown||unknown
+unneedingly||unnecessarily
+unsinged||unsigned
+unuseful||useless
+usefule||useful
+usefull||useful
+usege||usage
+usera||users
+usualy||usually
+utilites||utilities
+utillities||utilities
+utilties||utilities
+utiltity||utility
+utitlty||utility
+valide||valid
+variantions||variations
+varient||variant
+verbse||verbose
+verisons||versions
+verison||version
+verson||version
+vicefersa||vice-versa
+visiters||visitors
+vitual||virtual
+whataver||whatever
+wheter||whether
+wierd||weird
+writting||writing
-- 
1.9.1


-- 
Kees Cook
Chrome OS Security
